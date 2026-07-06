"""The all-facets melody scorecard — read where a line is weak across the whole craft.

Runs `framework.analysis` over a SINGLE line and prints a verdict per craft facet, so a rework
knows which research to apply where instead of guessing:

  hook/motif · contour & apex · interval & voice-leading · rhythm & timing ·
  harmonic exposure & NCTs · phrase & cadence

The thresholds (constants below) are a FLOOR to catch obvious weakness — a flat contour, no motif
development, a cramped range, downbeats that aren't chord tones, two-value rhythm. They are not a
grade; the ear is final. Use it to target work and to catch regressions, not to declare a melody good.

    python -m tools.melody_report RENN_FULL          # a theme var in symphony.materials.themes
    python -m tools.melody_report --all            # the six canonical themes
"""
from __future__ import annotations

import argparse
import statistics
from collections import Counter

from music21 import pitch as _P

from framework.analysis import analyze_full
from framework.analysis.core import Knobs
from framework.analysis.events import NoteEvent
from framework.analysis.tonal import NOTE_NAMES

# --- floors (swappable; chosen to flag obvious weakness, not to grade) -------------------------
MIN_RESTATEMENT = 0.25   # < this fraction of notes recurring as a motif => no memorable identity
MAX_APEX_HITS = 3        # the high point should be rationed; more hits => no single climax
APEX_EDGE = 0.12         # apex in the first/last 12% of the line => no shaped arc
MIN_RANGE = 5            # semitones; < a P4 of span => cramped ("staring at a turtle")
MAX_RANGE = 28
MIN_DISTINCT_DUR = 3     # <= 2 distinct note values => rhythmically monotonous
MIN_STRONGBEAT_CT = 0.70  # fraction of strong-beat notes that must be chord tones
MIN_DOWNBEAT_ROOT = 0.40  # fraction of bars whose downbeat lands the chord ROOT
NCT_LO, NCT_HI = 0.05, 0.45   # NCT rate band (none => stiff; too many => ambiguous)
BIG_LEAP = 5             # semitones; a leap of a P4+ wants stepwise recovery the other way

CANON = ["RENN_FULL", "ESHAIA_FULL", "STORYTELLER_FULL", "MEMORY_FULL", "ONSLAUGHT_FULL", "SAELITH"]


def _events(notelist):
    """NoteEvents from a (pitch, ql[, marks]) list; rests advance time; chords take the top note."""
    ev, t, rests = [], 0.0, 0
    for it in notelist:
        p = it[0]
        if p is None:
            rests += 1
        else:
            if isinstance(p, list):
                p = max(p, key=lambda x: _P.Pitch(x).midi)
            ev.append(NoteEvent(t, int(_P.Pitch(p).midi), float(it[1])))
        t += float(it[1])
    return ev, t, rests


def _v(ok, msg):
    return ("OK  " if ok else "FLAG") + "  " + msg


def report(notelist, name, beats=4.0):
    ev, total, rests = _events(notelist)
    if len(ev) < 4:
        print(f"\n### {name}: too short to analyse"); return
    notes, seg = analyze_full(ev, total, Knobs(beats_per_bar=beats))
    n = len(notes)
    H = [x.features["harmony"] for x in notes]
    M = [x.features["metric"] for x in notes]
    F = [x.features["figuration"] for x in notes]
    M0 = [x.features["motif"]["transform"] for x in notes]
    midis = [x.midi for x in notes]
    durs = [x.duration for x in notes]

    print(f"\n### {name}   ({n} notes, {rests} rests, ~{int(total/beats)} bars @ {beats:g}/bar)")

    # 1. hook / motif --------------------------------------------------------------------------
    restated = [t for t in M0 if t != "-"]
    rate = len(restated) / n
    kinds = Counter(restated)
    developing = any(k for k in kinds if k not in ("exact",))
    seqrate = sum(f["in_sequence"] for f in F) / n
    print("  motif/hook   ", _v(rate >= MIN_RESTATEMENT,
          f"{rate:.0%} of notes recur as a motif ({dict(kinds.most_common(4)) or 'none'}); "
          f"{'developing' if developing else 'only literal repeats' if kinds else 'no recurring cell'}; seq {seqrate:.0%}"))

    # 2. contour / apex ------------------------------------------------------------------------
    apex_hits = midis.count(max(midis))
    apex_ok = seg.archetype != "flat" and APEX_EDGE <= seg.apex_position <= 1 - APEX_EDGE and apex_hits <= MAX_APEX_HITS
    print("  contour/apex ", _v(apex_ok,
          f"archetype={seg.archetype}, apex at {seg.apex_position:.0%} of the line, "
          f"high note hit {apex_hits}x, range {seg.range_semitones}st"))
    print("  range        ", _v(MIN_RANGE <= seg.range_semitones <= MAX_RANGE,
          f"{seg.range_semitones} semitones ({NOTE_NAMES[min(midis)%12]}{min(midis)//12-1}–{NOTE_NAMES[max(midis)%12]}{max(midis)//12-1})"))

    # 3. interval / voice-leading --------------------------------------------------------------
    ivs = [midis[i + 1] - midis[i] for i in range(n - 1)]
    leaps = [v for v in ivs if abs(v) >= BIG_LEAP]
    unrec = 0
    for i in range(len(ivs) - 1):
        if abs(ivs[i]) >= BIG_LEAP and not (1 <= abs(ivs[i + 1]) <= 2 and ivs[i] * ivs[i + 1] < 0):
            unrec += 1
    forbidden = [v for v in ivs if abs(v) in (6, 11) or abs(v) > 12]
    print("  intervals/VL ", _v(unrec == 0,
          f"mean |iv| {seg.style['mean_interval']}st, {len(leaps)} leaps≥P4, {unrec} unrecovered, "
          f"{len(forbidden)} tritone/M7/>8ve"))

    # 4. rhythm / timing -----------------------------------------------------------------------
    ndur = len(set(round(d, 3) for d in durs))
    offbeat = sum(1 for m in M if m["strength"] == "offbeat")
    synco = sum(1 for i, m in enumerate(M) if m["strength"] == "offbeat" and durs[i] >= 1.0)
    rhythm_ok = ndur >= MIN_DISTINCT_DUR and (offbeat > 0 or ndur >= 4)
    print("  rhythm       ", _v(rhythm_ok,
          f"{ndur} distinct values, density {seg.style['note_density']}/beat, "
          f"{offbeat} off-beat onsets ({synco} agogic-syncopated)"))

    # 5. harmonic exposure / NCT ---------------------------------------------------------------
    bars: dict[int, list[int]] = {}
    for i, m in enumerate(M):
        bars.setdefault(m["bar"], []).append(i)
    implied, root_hits, strong, strong_ct = [], 0, 0, 0
    for b in sorted(bars):
        idxs = bars[b]
        db = min(idxs, key=lambda i: M[i]["bar_position"])
        implied.append(H[db]["roman"] + H[db]["inversion"])
        if H[db]["role"] == "ct:R":
            root_hits += 1
        for i in idxs:
            if M[i]["strength"] in ("downbeat", "halfbar"):
                strong += 1
                strong_ct += H[i]["role"].startswith("ct")
    nbars = len(bars)
    rootrate = root_hits / nbars
    sbct = strong_ct / max(strong, 1)
    ncts = [h["role"] for h in H if h["role"].startswith("nct")]
    nctrate = len(ncts) / n
    acc_nct = sum(1 for i, h in enumerate(H) if h["role"].startswith("nct") and M[i]["strength"] in ("downbeat", "halfbar"))
    print("  harmony-expose", _v(sbct >= MIN_STRONGBEAT_CT and rootrate >= MIN_DOWNBEAT_ROOT,
          f"{sbct:.0%} of strong beats are chord tones, downbeat=root in {root_hits}/{nbars} bars; "
          f"{acc_nct} accented NCTs"))
    print("  NCT/tension  ", _v(NCT_LO <= nctrate <= NCT_HI,
          f"{nctrate:.0%} NCTs ({dict(Counter(r.split(':')[1] for r in ncts).most_common(4)) or 'none'})"))

    # 6. phrase / cadence ----------------------------------------------------------------------
    degs = [x.features["tonal"]["degree"] for x in notes]
    end = [d for d in degs[-3:] if d is not None]
    cadence = bool(end) and end[-1] == 1 and (len(end) < 2 or end[-2] in (2, 7, 5, 4))
    print("  phrase/cad   ", _v(cadence,
          f"ends on scale-degrees {end or '?'}; {rests} rests for breath"))

    # the line's implied progression, bar by bar (determinacy at a glance) ----------------------
    print("  implies:      " + " ".join(implied))


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("name", nargs="?", help="a theme variable in symphony.materials.themes")
    ap.add_argument("--all", action="store_true", help="the six canonical themes")
    ap.add_argument("--beats", type=float, default=4.0, help="beats per bar (default 4)")
    args = ap.parse_args(argv)
    from symphony.materials import themes as T
    names = CANON if args.all else ([args.name] if args.name else None)
    if not names:
        ap.error("give a theme variable name or --all")
    for nm in names:
        if not hasattr(T, nm):
            print(f"\n### {nm}: not found in themes.py"); continue
        report(getattr(T, nm), nm, beats=args.beats)


if __name__ == "__main__":
    main()
