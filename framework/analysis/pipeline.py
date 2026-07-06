"""The orchestrator: build the shared context once, run every registered extractor, assemble
the per-note feature bundles.

To add a feature tier: write ``annotate(ctx, knobs) -> list[<value per melody note>]`` in a module
and add one ``(name, fn)`` line to ``EXTRACTORS``. Nothing else changes.
"""
from __future__ import annotations

from dataclasses import replace

from framework.analysis import basic, figuration, harmony, motif, segment
from framework.analysis.core import AnalysisContext, AnalyzedNote, Knobs
from framework.analysis.events import NoteEvent, events_from_midi, events_from_music21, melody_line
from framework.analysis.segment import SegmentFeatures
from framework.analysis.tonal import diatonic_ordinals, estimate_key, pc_histogram

# The registry. Order is only cosmetic — extractors are independent (figuration/harmony share the
# window product via the context, computed before any extractor runs).
EXTRACTORS = [
    (basic.TONAL, basic.annotate_tonal),
    (harmony.NAME, harmony.annotate),
    (figuration.NAME, figuration.annotate),
    (motif.NAME, motif.annotate),
    (basic.METRIC, basic.annotate_metric),
]


def _with_barlen(knobs: Knobs | None, barlen: float) -> Knobs:
    """Per-file knobs with the real metre, so harmony bars / metric / contour use the actual bar."""
    return replace(knobs or Knobs(), beats_per_bar=barlen)


def build_context(texture: list[NoteEvent], total: float, knobs: Knobs) -> AnalysisContext:
    """Compute the products every extractor shares: melody, global key, harmony windows, ordinals."""
    melody = melody_line(texture)
    key = estimate_key(pc_histogram(texture))
    windows = harmony.windowed_harmony(harmony.accompaniment(texture, melody), total, key, knobs)
    return AnalysisContext(melody=melody, texture=texture, total=total, key=key,
                           windows=windows, ordinals=diatonic_ordinals(*key))


def analyze_events(texture: list[NoteEvent], total: float, knobs: Knobs | None = None) -> list[AnalyzedNote]:
    """Run the full pipeline over a note-event texture; returns the annotated melody."""
    knobs = knobs or Knobs()
    ctx = build_context(texture, total, knobs)
    notes = [AnalyzedNote(e.onset, e.midi, e.duration) for e in ctx.melody]
    for name, fn in EXTRACTORS:
        values = fn(ctx, knobs)
        for note, value in zip(notes, values):
            note.features[name] = value
    return notes


def analyze_midi(path: str, knobs: Knobs | None = None) -> list[AnalyzedNote]:
    events, total, barlen = events_from_midi(path)
    return analyze_events(events, total, _with_barlen(knobs, barlen))


def analyze_score(score, knobs: Knobs | None = None) -> list[AnalyzedNote]:
    """Analyse a music21 score (e.g. a bundled-corpus chorale)."""
    events, total, barlen = events_from_music21(score)
    return analyze_events(events, total, _with_barlen(knobs, barlen))


def analyze_full(texture: list[NoteEvent], total: float, knobs: Knobs | None = None
                 ) -> tuple[list[AnalyzedNote], SegmentFeatures]:
    """Per-note features plus the segment-level shape + style summary (the control signals)."""
    knobs = knobs or Knobs()
    notes = analyze_events(texture, total, knobs)
    return notes, segment.summarize(notes, knobs)
