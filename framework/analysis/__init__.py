"""Musical feature extraction — analyse a full multi-part score into per-melody-note features.

Three validated tiers (harmony / figuration / motif) plus cheap tonal + metric tiers, each a
windowed, tunable, fully-automatic extractor (no hand-labelling). Feeds the planned neural model;
see ``docs/architecture/18_feature_extraction.md`` for the ontology, what is deliberately skipped
(local key), and how to extend.

    from framework.analysis import analyze_midi, Knobs
    notes = analyze_midi("song.mid")
    notes[0].features  # {'tonal': {...}, 'harmony': {...}, 'figuration': {...}, 'motif': {...}, 'metric': {...}}
"""
from __future__ import annotations

from framework.analysis.core import AnalysisContext, AnalyzedNote, Knobs
from framework.analysis.events import NoteEvent, events_from_midi, events_from_music21, melody_line
from framework.analysis.segment import SegmentFeatures, summarize
from framework.analysis.pipeline import (
    EXTRACTORS,
    analyze_events,
    analyze_full,
    analyze_midi,
    analyze_score,
    build_context,
)

__all__ = [
    "Knobs",
    "AnalyzedNote",
    "AnalysisContext",
    "SegmentFeatures",
    "summarize",
    "analyze_full",
    "NoteEvent",
    "events_from_midi",
    "events_from_music21",
    "melody_line",
    "analyze_events",
    "analyze_midi",
    "analyze_score",
    "build_context",
    "EXTRACTORS",
]
