"""Motif tier (structural recurrence): per-note transformation vs an earlier statement.

Slides a window over the melody and self-matches it against earlier windows under the
developing-variation transforms — exact, real transposition, inversion, tonal transposition /
inversion (via the key's diatonic ordinals), retrograde, augmentation / diminution. Each note is
labelled with the transform relating its cell to the nearest earlier statement, or '-'.
"""
from __future__ import annotations

from framework.analysis.core import AnalysisContext, Knobs

NAME = "motif"


def _tonal_intervals(pitches, ordinals):
    if all(p in ordinals for p in pitches):
        o = [ordinals[p] for p in pitches]
        return [o[k + 1] - o[k] for k in range(len(o) - 1)]
    return None


def classify(ref, cell) -> str | None:
    """Transform relating ``cell`` to reference ``ref`` (each (P, D, real_iv, tonal_iv)), or None."""
    refP, refD, refRI, refTI = ref
    P, D, RI, TI = cell
    neg = lambda xs: [-x for x in xs]
    if D == refD and RI == refRI:
        return "exact" if P == refP else f"transpose{P[0] - refP[0]:+d}"
    if D == refD and RI == neg(refRI):
        return "inversion"
    if D == refD and TI is not None and refTI is not None and TI == refTI and RI != refRI:
        return "tonal-transpose"
    if D == refD and TI is not None and refTI is not None and TI == neg(refTI):
        return "tonal-inversion"
    if RI == neg(list(reversed(refRI))) and D == list(reversed(refD)):
        return "retrograde"
    if RI == refRI and all(refD) and all(
        abs(D[k] / refD[k] - D[0] / refD[0]) < 1e-6 for k in range(len(D))
    ):
        factor = D[0] / refD[0]
        if abs(factor - 1) > 1e-6:
            return "augmentation" if factor > 1 else "diminution"
    return None


def detect(pitches, durations, ordinals, knobs: Knobs) -> list[str]:
    P, D, n = pitches, [round(d, 4) for d in durations], len(pitches)
    labels = ["-"] * n
    for length in knobs.cell_lengths:
        sigs = []
        for i in range(n - length + 1):
            p, d = P[i:i + length], D[i:i + length]
            ri = [p[k + 1] - p[k] for k in range(length - 1)]
            sigs.append((p, d, ri, _tonal_intervals(p, ordinals)))
        for i in range(length, n - length + 1):
            if any(labels[i + k] != "-" for k in range(length)):
                continue
            for j in range(i - length, -1, -1):       # nearest earlier, non-overlapping cell
                if j + length > i - knobs.motif_min_gap:
                    continue
                transform = classify(sigs[j], sigs[i])
                if transform:
                    for k in range(length):
                        labels[i + k] = transform
                    break
    return labels


def annotate(ctx: AnalysisContext, knobs: Knobs) -> list[dict]:
    P = [e.midi for e in ctx.melody]
    D = [e.duration for e in ctx.melody]
    labels = detect(P, D, ctx.ordinals, knobs)
    return [{"transform": labels[i]} for i in range(len(P))]
