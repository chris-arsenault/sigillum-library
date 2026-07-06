"""Core types for the feature pipeline: tunable knobs, the analysis context, the per-note bundle.

Kept dependency-free (only ``events``) so every extractor can import these without cycles. An
extractor is just ``annotate(ctx, knobs) -> list`` returning one value per melody note; the
pipeline stores it on each note under the extractor's name. New tier = new module + one registry
line — nothing here changes.
"""
from __future__ import annotations

from dataclasses import dataclass, field

from framework.analysis.events import NoteEvent


@dataclass(frozen=True)
class Knobs:
    """Every tunable in one place (all swappable; defaults are the validated prototype values)."""
    # harmony windowing (the STFT-like sweep)
    harm_window: float = 2.0       # window length in beats == the harmonic-rhythm scale
    harm_hop: float = 1.0          # overlap stride
    harm_taper: bool = True        # Hann edge taper
    harm_off_penalty: float = 0.55  # penalty on out-of-chord pc mass when matching
    # figuration
    step_max: int = 2              # semitones still counted as a melodic step
    leap_min: int = 3              # semitones counted as a leap
    min_run: int = 3               # notes in a row to call a scalar run
    min_arp: int = 3               # chord-tone leaps in a row to call an arpeggio
    sustain_x: float = 1.8         # duration >= this * median => sustained
    trill_max_dur: float = 0.5     # an alternation faster than this (beats) is a trill, else a rock
    # motif / transformation
    cell_lengths: tuple[int, ...] = (5, 4, 3)  # motif window lengths, longest tried first
    motif_min_gap: int = 0         # min note gap to a reference cell (0 = allow adjacent repeats)
    # metre (assumed; MIDI time-sig is unreliable)
    beats_per_bar: float = 4.0


@dataclass
class AnalysisContext:
    """Shared products computed once, read by every extractor."""
    melody: list[NoteEvent]          # the line being annotated (the melody voice's top line)
    texture: list[NoteEvent]         # the full multi-part texture (for harmony)
    total: float                     # length in beats
    key: tuple[int, str]             # global (tonic_pc, mode)
    windows: list[tuple]             # harmony windows (center, label, pcs, root, inversion)
    ordinals: dict[int, int]         # midi -> diatonic ordinal in the key


@dataclass
class AnalyzedNote:
    """One melody note plus its feature streams (open to new tiers via ``features``)."""
    onset: float
    midi: int
    duration: float
    features: dict[str, object] = field(default_factory=dict)
