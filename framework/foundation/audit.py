"""Dynamics + tempo audit — a MEASUREMENT (not a generator) over a movement's parts.

Catches three recurring gaps:
  - a voice entrance (first note, or first note after >=2 bars of rest) with no dynamic mark;
  - a deceleration direction (morendo/rit/rall/smorz/calando…) with no resolving `a tempo`
    after it (so the slow-down strands the tempo);
  - a dynamic range skewed to the extremes (lots of ppp/pp, an empty mp–mf–f middle).

Works on note-list parts: a list of (part_name, items) where items are (pitch, ql, *marks).
"""
import collections

DYN = ["ppp", "pp", "p", "mp", "mf", "f", "ff", "fff"]
_MID = {"mp", "mf", "f"}
_DECEL = ("morendo", "rit", "ritard", "rall", "smorz", "calando", "perdendo", "allarg", "slentando")
# false friends of the decel stems (esp. "rit" → "rite"/"ritual") — a word matching a stem
# is NOT a deceleration if it is one of these (it is some other word that happens to share the prefix).
_DECEL_FALSE_FRIENDS = frozenset({"rite", "rites", "ritual", "rituals", "ritually", "ritornello"})
_ATEMPO = ("a tempo", "tempo i", "tempo 1", "in tempo", "primo tempo")


def _marks(e):
    return [m for m in e[2:] if isinstance(m, str)]


def audit(parts, beats_per_bar=4.0, tail_bars=6):
    """Return findings dict. tail_bars = a decel within this many bars of the end is fine
    (the piece is allowed to die away at the close)."""
    hist = collections.Counter()
    missing = []          # (part, bar) entrances with no dynamic
    decels = []           # (part, bar, text)
    atempos = []          # (part, bar)
    total_bars = 0
    for name, items in parts:
        cur = None
        rest_run = 0.0
        t = 0.0
        first = True
        for e in items:
            p, d = e[0], e[1]
            bar = int(t // beats_per_bar) + 1
            ms = _marks(e)
            dyn = [m for m in ms if m in DYN]
            txt = " ".join(m[4:].lower() for m in ms if m.startswith("txt:"))
            words = txt.replace("-", " ").replace(".", " ").split()
            for dd in dyn:
                hist[dd] += 1
                cur = dd
            if any(w.startswith(stem) for w in words for stem in _DECEL
                   if w not in _DECEL_FALSE_FRIENDS):  # word-prefix, minus false friends (rite/ritual)
                decels.append((name, bar, txt))
            if any(ph in txt for ph in _ATEMPO):
                atempos.append((name, bar))
            if p is not None:
                # a voice's FIRST appearance with no dynamic = a new line introduced unmarked
                # (re-entries that carry an established dynamic are fine, not flagged)
                if (first or rest_run >= 2 * beats_per_bar) and not dyn and cur is None:
                    missing.append((name, bar))
                first = False
                rest_run = 0.0
            else:
                rest_run += d
            t += d
        total_bars = max(total_bars, int(round(t / beats_per_bar)))
    # an a tempo (or any later decel restart) resolves a decel if it comes after it
    atempo_bars = sorted(b for _, b in atempos)
    unresolved = []
    for name, bar, txt in decels:
        if bar >= total_bars - tail_bars:
            continue  # dying away at the close is fine
        if not any(ab > bar for ab in atempo_bars):
            unresolved.append((name, bar, txt))
    return {"hist": dict(hist), "missing_entrances": missing,
            "decels": decels, "atempos": atempos, "unresolved_tempo": unresolved,
            "total_bars": total_bars}


def format_audit(f):
    h = f["hist"]
    order = " · ".join(f"{d}:{h[d]}" for d in DYN if d in h)
    mid = sum(h.get(d, 0) for d in _MID)
    extremes = h.get("ppp", 0) + h.get("pp", 0) + h.get("fff", 0)
    lines = ["## Dynamics + tempo audit (auto-measured)",
             f"- dynamic range: {order or '(none)'}"]
    if mid <= extremes // 4:
        lines.append(f"  - ⚠ thin middle: mp/mf/f total {mid} vs ppp/pp/fff total {extremes} "
                     f"— reach for the working middle, not just the extremes")
    me = f["missing_entrances"]
    if me:
        lines.append(f"- ⚠ {len(me)} voice entrance(s) with no dynamic: "
                     + ", ".join(f"{n} b{b}" for n, b in me[:20]) + ("…" if len(me) > 20 else ""))
    else:
        lines.append("- every voice entrance carries a dynamic ✓")
    ut = f["unresolved_tempo"]
    if ut:
        lines.append(f"- ⚠ {len(ut)} deceleration(s) with no resolving `a tempo`: "
                     + ", ".join(f"{n} b{b} ({t})" for n, b, t in ut))
    else:
        lines.append("- tempo decelerations resolve (or fall at the close) ✓")
    return "\n".join(lines) + "\n"
