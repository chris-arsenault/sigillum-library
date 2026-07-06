"""Cheap per-note tiers: tonal degree and metric position. Reliable, no windowing needed."""
from __future__ import annotations

from framework.analysis.core import AnalysisContext, Knobs
from framework.analysis.tonal import scale_degree

TONAL = "tonal"
METRIC = "metric"


def annotate_tonal(ctx: AnalysisContext, knobs: Knobs) -> list[dict]:
    tonic, mode = ctx.key
    out = []
    for e in ctx.melody:
        degree = scale_degree(e.midi, tonic, mode)
        out.append({"degree": degree, "chromatic": degree is None, "octave": e.midi // 12 - 1})
    return out


def _strength(position: float, bpb: float) -> str:
    if abs(position) < 1e-6 or abs(position - bpb) < 1e-6:
        return "downbeat"
    if abs(position - bpb / 2.0) < 1e-6:
        return "halfbar"
    if abs(position - round(position)) < 1e-6:
        return "beat"
    return "offbeat"


def annotate_metric(ctx: AnalysisContext, knobs: Knobs) -> list[dict]:
    bpb = knobs.beats_per_bar
    out = []
    for e in ctx.melody:
        position = e.onset % bpb
        out.append({"bar": int(e.onset // bpb),
                    "bar_position": round(position, 4),
                    "strength": _strength(position, bpb),
                    "duration": e.duration})
    return out
