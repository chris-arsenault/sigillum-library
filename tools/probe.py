#!/usr/bin/env python3
"""probe.py <mid> <bar> [bar...] -- per-part sounding pitches per beat in given bars."""
import sys
from music21 import converter, note, chord

f = sys.argv[1]; bars = [int(b) for b in sys.argv[2:]]
sc = converter.parse(f)
for b in bars:
    print(f"--- {f} bar {b} ---")
    for p in sc.parts:
        nm = (p.partName or '?')
        ev = []
        for el in p.flatten().notes:
            off = float(el.offset); dur = float(el.quarterLength)
            s, e = off, off + dur
            b0, b1 = (b - 1) * 4.0, b * 4.0
            if s < b1 and e > b0:
                ps = [el.pitch] if isinstance(el, note.Note) else list(el.pitches)
                ev.append((max(s, b0) - b0, min(e, b1) - b0, '+'.join(x.nameWithOctave for x in ps)))
        if ev:
            print(f"  {nm:14s} " + "  ".join(f"[{a:.2g}-{bb:.2g}]{n}" for a, bb, n in sorted(ev)))
