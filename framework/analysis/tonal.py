"""Tonal primitives: pitch-class energy, key estimation, scale degrees, windowing.

Key/scale are the frame every other tier reads against. Key is estimated ONCE per analysed
segment (global) — by design we do not track local key / modulation (see the architecture doc:
the signal is noisy and the symphony supplies key drama by transposing whole themes). Modulating
training material is instead segmented into single-key spans upstream.
"""
from __future__ import annotations

import math

from framework.analysis.events import NoteEvent

# Krumhansl-Kessler key profiles.
_KS_MAJOR = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88]
_KS_MINOR = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17]

NOTE_NAMES = ["C", "C#", "D", "E-", "E", "F", "F#", "G", "G#", "A", "B-", "B"]

# Scale-degree offsets from the tonic (minor is harmonic-minor-flavoured to match the dominant).
SCALE_OFFSETS = {"major": (0, 2, 4, 5, 7, 9, 11), "minor": (0, 2, 3, 5, 7, 8, 11)}


def pc_histogram(events, lo=0.0, hi=None, *, taper=False, center=None, width=None) -> list[float]:
    """Duration-weighted pitch-class energy over ``[lo, hi)``, optionally Hann-tapered to center.

    The taper (the user's STFT framing) down-weights notes near the window edges, so a sonority
    straddling a chord change does not muddy the window it only partly overlaps.
    """
    hist = [0.0] * 12
    for e in events:
        a = max(e.onset, lo)
        b = min(e.onset + e.duration, hi) if hi is not None else e.onset + e.duration
        if b <= a:
            continue
        weight = b - a
        if taper and width:
            mid = (a + b) / 2.0
            weight *= 0.5 * (1 + math.cos(math.pi * min(abs(mid - center) / (width / 2.0), 1.0)))
        hist[e.midi % 12] += weight
    return hist


def estimate_key(hist) -> tuple[int, str]:
    """Best ``(tonic_pc, mode)`` by Krumhansl correlation over all 24 rotations."""
    def corr(profile, h):
        n = len(h)
        mp, mh = sum(profile) / n, sum(h) / n
        num = sum((profile[i] - mp) * (h[i] - mh) for i in range(n))
        den = math.sqrt(sum((profile[i] - mp) ** 2 for i in range(n))
                        * sum((h[i] - mh) ** 2 for i in range(n)))
        return num / den if den else -1.0
    best, score = (0, "major"), -2.0
    for tonic in range(12):
        rotated = hist[tonic:] + hist[:tonic]
        for mode, profile in (("major", _KS_MAJOR), ("minor", _KS_MINOR)):
            c = corr(profile, rotated)
            if c > score:
                best, score = (tonic, mode), c
    return best


def diatonic_ordinals(tonic: int, mode: str) -> dict[int, int]:
    """midi -> diatonic ordinal (increments by 1 per scale step); non-scale midis omitted.

    Lets tonal (scale-step) intervals be computed by subtraction, so "a third is a third"
    regardless of major/minor quality — the basis for tonal sequence / transposition detection.
    """
    pcs = {(tonic + off) % 12 for off in SCALE_OFFSETS[mode]}
    return {m: i for i, m in enumerate(m for m in range(128) if m % 12 in pcs)}


def scale_degree(midi: int, tonic: int, mode: str) -> int | None:
    """Scale degree 1-7 of ``midi`` in the key, or ``None`` if chromatic (non-scale)."""
    offs = SCALE_OFFSETS[mode]
    pc = (midi - tonic) % 12
    return offs.index(pc) + 1 if pc in offs else None
