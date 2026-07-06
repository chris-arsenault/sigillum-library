"""Segment-level features: SHAPE (overall contour) and a computed STYLE fingerprint.

Unlike the per-note tiers, these summarise a whole melody (or phrase) — they are the control
signals the model is *told* (an arc to follow, a character to write in), learned from the corpus
the same way harmony is. ``character`` proper is mostly provenance (the source category / a
kernel's role) and rides in as a label; what we *compute* here is the style fingerprint — the
behavioural signature (angular vs stepwise, chromatic vs diatonic, busy vs sparse) that the
figuration/harmony/tonal tiers already discriminate styles by.
"""
from __future__ import annotations

import statistics
from collections import Counter
from dataclasses import dataclass

from framework.analysis.core import AnalyzedNote, Knobs

# Non-diatonic Roman-numeral roots (chromatic harmony: modal mixture / Neapolitan / applied).
_CHROMATIC_HARMONY = {"b", "/"}


@dataclass(frozen=True)
class SegmentFeatures:
    contour: tuple[float, ...]   # per-bar normalised average pitch in [0,1]
    archetype: str               # rising / falling / arch / valley / flat
    apex_position: float         # where the highest note sits, 0 (start) .. 1 (end)
    range_semitones: int
    style: dict                  # behavioural fingerprint (see summarize)


def _archetype(contour: tuple[float, ...]) -> str:
    if len(contour) < 2:
        return "flat"
    third = max(1, len(contour) // 3)
    start = statistics.mean(contour[:third])
    middle = statistics.mean(contour[third:-third] or contour)
    end = statistics.mean(contour[-third:])
    rise, fall = end - start, start - end
    if middle - max(start, end) > 0.15:
        return "arch"
    if min(start, end) - middle > 0.15:
        return "valley"
    if rise > 0.15:
        return "rising"
    if fall > 0.15:
        return "falling"
    return "flat"


def summarize(notes: list[AnalyzedNote], knobs: Knobs | None = None) -> SegmentFeatures:
    """Whole-melody shape + style fingerprint from the per-note analysis."""
    knobs = knobs or Knobs()
    if not notes:
        return SegmentFeatures((), "flat", 0.0, 0, {})
    pitches = [n.midi for n in notes]
    lo, hi = min(pitches), max(pitches)
    span = max(hi - lo, 1)
    total = max(n.onset + n.duration for n in notes) or 1.0

    # contour: per-bar average pitch, normalised over the melody's range
    bars: dict[int, list[int]] = {}
    for n in notes:
        bars.setdefault(int(n.onset // knobs.beats_per_bar), []).append(n.midi)
    contour = tuple(round((statistics.mean(bars[b]) - lo) / span, 3) for b in sorted(bars))

    apex_onset = max(notes, key=lambda n: n.midi).onset
    intervals = [abs(pitches[i + 1] - pitches[i]) for i in range(len(pitches) - 1)]
    figures = Counter(n.features["figuration"]["figure"] for n in notes)
    chromatic = sum(n.features["tonal"]["chromatic"] for n in notes)
    non_diatonic = sum(any(c in n.features["harmony"]["roman"] for c in _CHROMATIC_HARMONY)
                       for n in notes)

    style = {
        "figuration_profile": {k: round(v / len(notes), 3) for k, v in figures.most_common()},
        "chromatic_rate": round(chromatic / len(notes), 3),
        "note_density": round(len(notes) / total, 3),           # notes per beat
        "mean_interval": round(statistics.mean(intervals), 2) if intervals else 0.0,
        "harmonic_color": round(non_diatonic / len(notes), 3),  # fraction over non-diatonic chords
    }
    return SegmentFeatures(contour, _archetype(contour), round(apex_onset / total, 3), span, style)
