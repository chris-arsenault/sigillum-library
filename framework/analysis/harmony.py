"""Harmony tier (vertical): windowed functional analysis + per-melody-note harmonic function.

Slides a tapered window over the ACCOMPANIMENT (texture minus melody, so a chromatic melody note
can't rewrite the chord), matches each window's pitch-class energy to a key-relative vocabulary of
functional chords (diatonic + modal mixture + Neapolitan + applied dominants), and reads each
melody note against the governing chord as a chord tone (R/3/5/7) or a typed non-chord-tone.
"""
from __future__ import annotations

from framework.analysis.core import AnalysisContext, Knobs
from framework.analysis.events import NoteEvent
from framework.analysis.tonal import estimate_key, pc_histogram

NAME = "harmony"

# Chord position by interval above the chord root (triad/7th tones only).
_CHORD_TONE = {0: "R", 3: "3", 4: "3", 6: "5", 7: "5", 8: "5", 10: "7", 11: "7"}


def chord_vocab(tonic: int, mode: str) -> list[tuple[str, frozenset[int], int]]:
    """(roman label, absolute pc set, root pc) — diatonic + mixture + Neapolitan + applied V."""
    if mode == "major":
        spec = {
            "I": (0, (0, 4, 7)), "ii": (2, (2, 5, 9)), "iii": (4, (4, 7, 11)),
            "IV": (5, (5, 9, 0)), "V": (7, (7, 11, 2)), "vi": (9, (9, 0, 4)),
            "vii°": (11, (11, 2, 5)),
            "V7": (7, (7, 11, 2, 5)), "ii7": (2, (2, 5, 9, 0)), "IM7": (0, (0, 4, 7, 11)),
            "vii°7": (11, (11, 2, 5, 8)),
            "iv": (5, (5, 8, 0)), "bVI": (8, (8, 0, 3)), "bVII": (10, (10, 2, 5)),
            "bIII": (3, (3, 7, 10)), "ii°": (2, (2, 5, 8)), "bII": (1, (1, 5, 8)),
            "V/V": (2, (2, 6, 9)), "V7/V": (2, (2, 6, 9, 0)), "V/vi": (4, (4, 8, 11)),
            "V/ii": (9, (9, 1, 4)), "vii°7/V": (1, (1, 4, 7, 10)),
        }
    else:
        spec = {
            "i": (0, (0, 3, 7)), "ii°": (2, (2, 5, 8)), "III": (3, (3, 7, 10)),
            "iv": (5, (5, 8, 0)), "v": (7, (7, 10, 2)), "V": (7, (7, 11, 2)),
            "VI": (8, (8, 0, 3)), "bVII": (10, (10, 2, 5)), "vii°": (11, (11, 2, 5)),
            "V7": (7, (7, 11, 2, 5)), "vii°7": (11, (11, 2, 5, 8)), "iv7": (5, (5, 8, 0, 3)),
            "III+": (3, (3, 7, 11)), "bII": (1, (1, 4, 8)),
            "V/III": (10, (10, 2, 5)), "V/iv": (0, (0, 4, 7)), "V/VI": (3, (3, 7, 10)),
        }
    return [(label, frozenset((tonic + p) % 12 for p in pcs), (tonic + root) % 12)
            for label, (root, pcs) in spec.items()]


def best_chord(hist, vocab, off_penalty):
    """Match window pc energy to the vocabulary: reward in-chord mass, penalise out-of-chord."""
    total = sum(hist) or 1.0
    norm = [h / total for h in hist]
    best = ("-", frozenset(), 0, -9.0)
    for label, pcs, root in vocab:
        score = sum(norm[pc] * (1.0 if pc in pcs else -off_penalty) for pc in range(12))
        if score > best[3]:
            best = (label, pcs, root, score)
    return best


def _bass_pc(events, lo, hi):
    sounding = [e for e in events if e.onset < hi and e.onset + e.duration > lo]
    return min(sounding, key=lambda e: e.midi).midi % 12 if sounding else None


def windowed_harmony(events, total, key, knobs: Knobs):
    """Per window: (center, roman_label, pcs, root, inversion-figure)."""
    vocab = chord_vocab(*key)
    out, center = [], knobs.harm_window / 2.0
    while center - knobs.harm_window / 2.0 < total:
        lo, hi = center - knobs.harm_window / 2.0, center + knobs.harm_window / 2.0
        hist = pc_histogram(events, lo, hi, taper=knobs.harm_taper, center=center,
                            width=knobs.harm_window)
        if sum(hist) > 1e-6:
            label, pcs, root, _ = best_chord(hist, vocab, knobs.harm_off_penalty)
            bass = _bass_pc(events, lo, hi)
            inv = "" if (bass is None or not pcs or bass == root) else "/" + _CHORD_TONE.get((bass - root) % 12, "x")
            out.append((center, label, pcs, root, inv))
        center += knobs.harm_hop
    return out


def accompaniment(texture: list[NoteEvent], melody: list[NoteEvent]) -> list[NoteEvent]:
    """Texture minus the melody line, so the tune's chromatics don't flip the inferred chord."""
    mel_keys = {(round(e.onset, 4), e.midi) for e in melody}
    rest = [e for e in texture if (round(e.onset, 4), e.midi) not in mel_keys]
    return rest or texture


def note_role(prev_midi, midi, next_midi, pcs, root) -> str:
    """Chord tone (ct:R/3/5/7) or non-chord-tone type for melody pitch against the governing chord."""
    if midi % 12 in pcs:
        return "ct:" + _CHORD_TONE.get((midi % 12 - root) % 12, "?")
    if prev_midi is None or next_midi is None:
        return "nct:?"
    into, out = midi - prev_midi, next_midi - midi
    step = lambda x: 1 <= abs(x) <= 2
    if prev_midi == midi and step(out):
        return "nct:susp"
    if midi == next_midi:
        return "nct:antic"
    if step(into) and step(out):
        return "nct:passing" if (into > 0) == (out > 0) else "nct:neighbor"
    if abs(into) > 2 and step(out):
        return "nct:appog"
    if step(into) and abs(out) > 2:
        return "nct:escape"
    return "nct:chromatic"


def chord_at(windows, onset):
    """Governing window chord nearest ``onset`` -> (label, pcs, root, inversion)."""
    if not windows:
        return "-", frozenset(), 0, ""
    w = min(windows, key=lambda w: abs(w[0] - onset))
    return w[1], w[2], w[3], w[4]


def annotate(ctx: AnalysisContext, knobs: Knobs) -> list[dict]:
    mel = ctx.melody
    out = []
    for i, e in enumerate(mel):
        label, pcs, root, inv = chord_at(ctx.windows, e.onset)
        prev_m = mel[i - 1].midi if i else None
        next_m = mel[i + 1].midi if i + 1 < len(mel) else None
        out.append({"roman": label, "inversion": inv,
                    "role": note_role(prev_m, e.midi, next_m, pcs, root)})
    return out
