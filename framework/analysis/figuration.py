"""Figuration tier (horizontal): per-note melodic figure + real-sequence flag.

Classifies each melody note from its local interval/rhythm context — scalar run, arpeggiation
(chord-tone leaps, told apart from a bare leap by the harmony tier), trill (fast alternation) vs
neighbour (slow), leap, step, repeat, sustained — and flags notes inside an interval-exact
sequence.
"""
from __future__ import annotations

import statistics

from framework.analysis.core import AnalysisContext, Knobs

NAME = "figuration"


def _chain(pitches, ok) -> list[bool]:
    """Mark notes in a maximal chain (>= 3 notes) where ``ok(start, i)`` holds for each step."""
    n = len(pitches)
    member = [False] * n
    i = 0
    while i < n - 1:
        j = i
        while j < n - 1 and ok(i, j):
            j += 1
        if j - i >= 2:
            for k in range(i, j + 1):
                member[k] = True
            i = j
        else:
            i += 1
    return member


def figuration(pitches, durations, is_chord_tone, knobs: Knobs) -> list[str]:
    n = len(pitches)
    if n == 0:
        return []
    median = statistics.median(durations)
    P, D = pitches, durations

    same_dir_step = lambda i, j: (
        knobs.step_max >= abs(P[j + 1] - P[j]) >= 1 and (P[j + 1] - P[j]) * (P[i + 1] - P[i]) > 0
    )
    chord_leap = lambda i, j: abs(P[j + 1] - P[j]) >= knobs.leap_min and is_chord_tone[j] and is_chord_tone[j + 1]
    runs = _chain(P, same_dir_step)
    arps = _chain(P, chord_leap)

    labels = []
    for k in range(n):
        din = P[k] - P[k - 1] if k > 0 else None
        dout = P[k + 1] - P[k] if k < n - 1 else None
        alternation = 0 < k < n - 1 and P[k - 1] == P[k + 1]
        if din == 0 or dout == 0:
            labels.append("repeat")
        elif runs[k]:
            d = dout if (dout and 1 <= abs(dout) <= knobs.step_max) else din
            labels.append("run-up" if d > 0 else "run-dn")
        elif arps[k]:
            d = dout if (dout and abs(dout) >= knobs.leap_min) else din
            labels.append("arp-up" if (d or 0) > 0 else "arp-dn")
        elif alternation and 1 <= abs(din) <= knobs.step_max:
            sustained_alt = (k >= 2 and P[k - 2] == P[k]) or (k + 2 < n and P[k + 2] == P[k])
            if sustained_alt and D[k] <= knobs.trill_max_dur:
                labels.append("trill")
            else:
                labels.append("neighbor-up" if din > 0 else "neighbor-dn")
        elif din is not None and abs(din) >= knobs.leap_min:
            labels.append("leap")
        elif D[k] >= knobs.sustain_x * median:
            labels.append("sustained")
        else:
            labels.append("step")
    return labels


def sequences(pitches, min_cell=2, max_cell=4) -> list[bool]:
    """Flag notes inside a real (interval-exact) sequence: an interval cell that repeats."""
    iv = [pitches[i + 1] - pitches[i] for i in range(len(pitches) - 1)]
    seq = [False] * len(pitches)
    for length in range(max_cell, min_cell - 1, -1):
        for k in range(len(iv) - 2 * length + 1):
            if iv[k:k + length] == iv[k + length:k + 2 * length]:
                for x in range(k, k + 2 * length + 1):
                    seq[x] = True
    return seq


def annotate(ctx: AnalysisContext, knobs: Knobs) -> list[dict]:
    from framework.analysis.harmony import chord_at
    P = [e.midi for e in ctx.melody]
    D = [e.duration for e in ctx.melody]
    is_ct = []
    for e in ctx.melody:
        _, pcs, _, _ = chord_at(ctx.windows, e.onset)
        is_ct.append(e.midi % 12 in pcs)
    figs = figuration(P, D, is_ct, knobs)
    seq = sequences(P)
    return [{"figure": figs[i], "in_sequence": seq[i]} for i in range(len(P))]
