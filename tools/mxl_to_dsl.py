"""Import hand-edited MusicXML into production-DSL event streams, with a diff gate.

Two subcommands support the hand-edit round-trip (notation app -> DSL source):

    # 1. Convert a hand-edited score into DSL phrase bodies (concert pitch,
    #    ties merged, dynamics/articulations/slurs/technique words inline):
    python -m tools.mxl_to_dsl convert "Flows from X/score.musicxml" \
        --bars 1-84 --segments "bridge:41-44,ladder:45-52,gm_a:53-68" \
        --perc-map D3=C3

    # 2. After pasting the bodies into section files and exporting, verify the
    #    export against the hand file at sounding pitch (zero diffs = faithful):
    python -m tools.mxl_to_dsl verify "Flows from X/score.musicxml" \
        outputs/.../piece.musicxml --bars 1-84 --perc-map D3=C3

See ``docs/architecture/orchestral_dsl/07_hand_edit_import.md``.
"""
import argparse
import re
import sys
import xml.etree.ElementTree as ET
from fractions import Fraction

CHORD_WORD = re.compile(r"^[A-G][#b]?(m|dim7?|maj7|m7b5|m7|sus[24]|aug|7|9)*$")

STEPS = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
STEP_PC = {"C": 0, "D": 2, "E": 4, "F": 5, "G": 7, "A": 9, "B": 11}
ART = {"staccato": "stacc", "accent": "accent", "strong-accent": "marc",
       "tenuto": "ten", "detached-legato": "ten"}
KIND = {"major": "", "minor": "m", "dominant": "7", "diminished": "dim",
        "diminished-seventh": "dim7", "half-diminished": "m7b5",
        "minor-seventh": "m7", "major-seventh": "maj7",
        "dominant-seventh": "7", "suspended-fourth": "sus4",
        "augmented": "aug"}
PART_KEYS = ("flute", "trumpet", "trombone", "violin", "violoncello", "cello",
             "contrabass", "bass", "percussion")


def norm_part(name):
    n = name.lower()
    # percussion kit pieces first: "bass drum" must not fall into "bass"
    if "snare" in n or n == "percussion":
        return "percussion"  # a hand file's single percussion staff is the snare line
    if "bass drum" in n:
        return "bass_drum"
    if "cymbal" in n:
        return "cymbal"
    for k in PART_KEYS:
        if k in n:
            return {"violoncello": "cello", "contrabass": "bass"}.get(k, k)
    return n or "?"


def midi_to_label(midi):
    return STEPS[midi % 12] + str(midi // 12 - 1)


def label_to_midi(label):
    m = re.match(r"([A-G])([#b]*)(-?\d+)", label)
    step, acc, octv = m.group(1), m.group(2), int(m.group(3))
    return ((octv + 1) * 12 + STEP_PC[step]
            + acc.count("#") - acc.count("b"))


def fmt_dur(fr):
    f = Fraction(fr)
    if f.denominator == 1:
        return str(f.numerator)
    if f.denominator in (2, 4):
        return str(float(f)).rstrip("0").rstrip(".").replace("0.", ".")
    return f"{f.numerator}/{f.denominator}"


def slug(text):
    return text.strip().replace(" ", "_").replace("é", "e").replace("è", "e")


def load_parts(path, last_bar, perc_map):
    """Parse a MusicXML file into per-part note/direction streams.

    Returns (parts, harmony_track, meta) where parts maps a normalized part
    name to a list of note dicts (bar, onset, midi|None, dur, marks, tie),
    harmony_track maps (bar, onset) -> chord label, and meta is a list of
    (part, bar, kind, text) rows for keys/tempi/wedges.

    Pitches are converted to CONCERT pitch using each part's transpose
    element (Bb trumpet, octave-transposing bass, ...). Percussion display
    pitches are remapped through perc_map (e.g. {"D3": "C3"}).
    """
    tree = ET.parse(path)
    root = tree.getroot()
    names = {sp.get("id"): (sp.findtext("part-name") or sp.get("id")).strip()
             for sp in root.findall(".//score-part")}
    parts, harmony_track, meta = {}, {}, []
    for part in root.findall("part"):
        pname = norm_part(names[part.get("id")])
        tr = part.find(".//transpose")
        chromatic = int(tr.findtext("chromatic", "0")) if tr is not None else 0
        octch = int(tr.findtext("octave-change", "0")) if tr is not None else 0
        divisions = 1
        notes = []
        bar_fill = {}  # bar number -> ql already consumed by earlier split segments
        for m in part.findall("measure"):
            raw = m.get("number")
            # Dorico splits a notated bar at mid-bar barlines/system events and
            # numbers the continuation "X<n>" (implicit). Treat it as bar <n>
            # continued: onsets resume where the first segment stopped.
            mm = re.match(r"^X?(\d+)$", raw or "")
            if not mm:
                continue
            num = int(mm.group(1))
            if num > last_bar:
                break
            d = m.find("attributes/divisions")
            if d is not None:
                divisions = int(d.text)
            k = m.find("attributes/key/fifths")
            if k is not None:
                meta.append((pname, num, "key",
                             f"fifths={k.text} mode={m.findtext('attributes/key/mode')}"))
            cursor = bar_fill.get(num, Fraction(0))
            pending = []  # direction payloads waiting for the next note
            for ch in m:
                if ch.tag == "backup":
                    cursor -= Fraction(int(ch.findtext("duration")), divisions)
                elif ch.tag == "forward":
                    cursor += Fraction(int(ch.findtext("duration")), divisions)
                elif ch.tag == "harmony":
                    rs = ch.findtext("root/root-step")
                    if rs:
                        ra = int(ch.findtext("root/root-alter", "0"))
                        kind = ch.find("kind")
                        label = rs + {1: "#", -1: "b"}.get(ra, "")
                        ktext = kind.get("text") if kind is not None else None
                        if ktext is not None:
                            label += ktext
                        elif kind is not None:
                            label += KIND.get(kind.text, kind.text or "")
                        harmony_track.setdefault((num, cursor), label)
                elif ch.tag == "direction":
                    payload = []
                    dt = ch.find(".//dynamics")
                    if dt is not None and len(dt):
                        payload.append(dt[0].tag)
                    for w in ch.findall("direction-type/words"):
                        # chord-name words duplicate the harmony track; skip
                        if w.text and not CHORD_WORD.match(w.text.strip()):
                            payload.append("txt:" + slug(w.text))
                    metro = ch.find(".//metronome")
                    if metro is not None:
                        meta.append((pname, num, "tempo",
                                     f"{metro.findtext('beat-unit')}={metro.findtext('per-minute')}"))
                    wedge = ch.find(".//wedge")
                    if wedge is not None:
                        meta.append((pname, num, "wedge", wedge.get("type")))
                    if payload:
                        pending.append((cursor, payload))
                elif ch.tag == "note":
                    if ch.find("chord") is not None or ch.find("grace") is not None:
                        meta.append((pname, num, "warning",
                                     "chord or grace note skipped"))
                        continue
                    dur = Fraction(int(ch.findtext("duration", "0")), divisions)
                    onset = cursor
                    cursor += dur
                    marks = [ART[a.tag] for a in ch.findall(".//articulations/*")
                             if a.tag in ART]
                    for sl in ch.findall(".//slur"):
                        marks.append("slur(" if sl.get("type") == "start" else "slur)")
                    arp = ch.find(".//notations/arpeggiate")
                    if arp is not None:
                        direction = arp.get("direction")
                        marks.append(f"arp:{direction}" if direction else "arp")
                    for gl in ch.findall(".//glissando") + ch.findall(".//slide"):
                        marks.append("gliss(" if gl.get("type") == "start" else "gliss)")
                    if any(t.get("type") == "let-ring"
                           for t in ch.findall(".//notations/tied")):
                        marks.append("lv")
                    ties = {t.get("type") for t in ch.findall("tie")}
                    if ch.find("rest") is not None:
                        notes.append({"bar": num, "onset": onset, "midi": None,
                                      "dur": dur, "marks": marks, "tie": ties})
                        continue
                    p = ch.find("pitch")
                    if p is not None:
                        midi = ((int(p.findtext("octave")) + 1) * 12
                                + STEP_PC[p.findtext("step")]
                                + int(p.findtext("alter", "0"))
                                + chromatic + 12 * octch)
                    else:
                        up = ch.find("unpitched")
                        label = ((up.findtext("display-step") or "C")
                                 + (up.findtext("display-octave") or "4"))
                        midi = label_to_midi(perc_map.get(label, label))
                    notes.append({"bar": num, "onset": onset, "midi": midi,
                                  "dur": dur, "marks": marks, "tie": ties})
            # attach pending directions to the note at/after their offset
            for doff, payload in pending:
                target = None
                for n in notes:
                    if n["bar"] == num and n["onset"] >= doff and n["midi"] is not None:
                        target = n
                        break
                if target is None:
                    for n in notes:
                        if (n["bar"], n["onset"]) >= (num, doff):
                            target = n
                            break
                if target is None and notes:
                    target = notes[-1]
                if target is not None:
                    target["marks"] = payload + target["marks"]
            bar_fill[num] = cursor
        parts[pname] = notes
    return parts, harmony_track, meta


def merge_ties(notes):
    """Merge tied same-pitch note chains into single longer events."""
    merged, i = [], 0
    while i < len(notes):
        e = notes[i]
        if e["midi"] is not None and "start" in e["tie"]:
            total, marks, j = e["dur"], list(e["marks"]), i + 1
            while j < len(notes):
                ej = notes[j]
                if ej["midi"] == e["midi"] and "stop" in ej["tie"]:
                    total += ej["dur"]
                    marks += [mk for mk in ej["marks"] if mk not in marks]
                    j += 1
                    if "start" not in ej["tie"]:
                        break
                else:
                    break
            merged.append({"bar": e["bar"], "midi": e["midi"], "dur": total,
                           "marks": marks})
            i = j
        else:
            merged.append({"bar": e["bar"], "midi": e["midi"], "dur": e["dur"],
                           "marks": e["marks"]})
            i += 1
    return merged


def fill_and_slice(notes, first, last, beats_per_bar):
    """Slice to a bar range, inserting whole-bar rests for missing bars."""
    have = {n["bar"] for n in notes}
    out = [n for n in notes if first <= n["bar"] <= last]
    for num in range(first, last + 1):
        if num not in have:
            out.append({"bar": num, "onset": Fraction(0), "midi": None,
                        "dur": Fraction(beats_per_bar), "marks": [],
                        "tie": set()})
    out.sort(key=lambda n: (n["bar"], n.get("onset", Fraction(0))))
    return out


def max_content_bar(parts):
    return max((n["bar"] for notes in parts.values() for n in notes
                if n["midi"] is not None), default=1)


def cmd_convert(args):
    first, last = args.bars
    perc_map = dict(m.split("=") for m in args.perc_map)
    parts, harmony, meta = load_parts(args.score, last, perc_map)
    last = min(last, max_content_bar(parts))
    segments = args.segments or [("all", first, last)]
    print(f"# Converted from: {args.score}")
    print(f"# Bars {first}-{last}; concert pitch; ties merged; durations quarter=1.")
    print("# Paste each block into a `phrase ... events %q{ ... }` body.")
    for pname, notes in parts.items():
        print(f"\n#### {pname} ####")
        for pn, bar, kind, text in meta:
            if pn == pname and first <= bar <= last and kind != "key":
                print(f"  # m{bar}: {kind.upper()} {text}")
        for seg, a, b in segments:
            body = merge_ties(fill_and_slice(notes, a, b, args.beats))
            if all(e["midi"] is None for e in body):
                print(f"-- {seg}: ALL RESTS (bars {a}-{b})")
                continue
            print(f"-- {seg} (bars {a}-{b}):")
            cur, line = None, []
            for e in body:
                if cur is None:
                    cur = e["bar"]
                if e["bar"] != cur:
                    print("          " + " ".join(line) + " |")
                    line, cur = [], e["bar"]
                tok = (midi_to_label(e["midi"]) if e["midi"] is not None else "r")
                tok += ":" + fmt_dur(e["dur"])
                if e["marks"]:
                    tok += "{" + ",".join(e["marks"]) + "}"
                line.append(tok)
            if line:
                print("          " + " ".join(line))
    if harmony:
        print("\n#### HARMONY TRACK (chord symbols) ####")
        for (bar, off), label in sorted(harmony.items()):
            if first <= bar <= last:
                beat = 1 + float(off)
                print(f'    text "{label}", at: "bar {bar} beat {beat:g}", for: :all')
    keys = sorted({(bar, text) for pn, bar, kind, text in meta
                   if kind == "key" and first <= bar <= last})
    if keys:
        print("\n#### KEY SIGNATURES (first part shown; transposing parts differ) ####")
        for bar, text in keys:
            print(f"  m{bar}: {text}")


def cmd_verify(args):
    first, last = args.bars
    perc_map = dict(m.split("=") for m in args.perc_map)
    sides = []
    for path in (args.hand, args.export):
        parts, _, _ = load_parts(path, last, perc_map)
        last = min(last, max_content_bar(parts))
        bars_by_part = {}
        for pname, notes in parts.items():
            rebars = {}
            for e in merge_ties(fill_and_slice(notes, first, last, args.beats)):
                rebars.setdefault(e["bar"], []).append((e["midi"], e["dur"]))
            bars_by_part[pname] = rebars
        sides.append(bars_by_part)
    hand, exp = sides

    print(f"comparing bars {first}-{last} (pass --bars to widen/narrow)")

    def normevs(evs):
        out = []
        for m, d in evs:
            if d == 0:
                continue
            if out and m is None and out[-1][0] is None:
                out[-1] = (None, out[-1][1] + d)
            else:
                out.append((m, d))
        return out

    total = 0
    for pname in sorted(set(hand) & set(exp)):
        diffs = [num for num in range(first, last + 1)
                 if normevs(hand[pname].get(num, []))
                 != normevs(exp[pname].get(num, []))]
        total += len(diffs)
        print(f"{pname}: " + ("OK" if not diffs
                              else f"DIFF at bars {diffs[:24]}"))
    for pname in sorted(set(hand).symmetric_difference(set(exp))):
        side = hand.get(pname) or exp.get(pname)
        has_notes = any(m is not None for evs in side.values() for m, _ in evs)
        if has_notes:
            print(f"{pname}: only on one side WITH notes in range")
            total += 1
        else:
            print(f"{pname}: only on one side (all rests in range - OK)")
    print("TOTAL differing bars:", total)
    return 1 if total else 0


def parse_bars(text):
    a, b = text.split("-")
    return int(a), int(b)


def parse_segments(text):
    segs = []
    for item in text.split(","):
        name, rng = item.split(":")
        a, b = rng.split("-")
        segs.append((name.strip(), int(a), int(b)))
    return segs


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("convert", help="MusicXML -> DSL phrase bodies")
    c.add_argument("score", help="hand-edited MusicXML file")
    c.add_argument("--bars", type=parse_bars, default=(1, 10_000),
                   metavar="A-B", help="bar range to convert (default: all)")
    c.add_argument("--segments", type=parse_segments, metavar="name:A-B,...",
                   help="split output into named phrase segments")
    c.add_argument("--perc-map", action="append", default=[], metavar="D3=C3",
                   help="remap percussion display pitches (repeatable)")
    c.add_argument("--beats", type=int, default=2,
                   help="beats per bar for rest fill (default 2 for 2/4)")
    v = sub.add_parser("verify", help="diff hand file vs DSL export at sounding pitch")
    v.add_argument("hand", help="hand-edited MusicXML (source of truth)")
    v.add_argument("export", help="DSL-exported MusicXML")
    v.add_argument("--bars", type=parse_bars, default=(1, 10_000), metavar="A-B")
    v.add_argument("--perc-map", action="append", default=[], metavar="D3=C3")
    v.add_argument("--beats", type=int, default=2)
    args = ap.parse_args(argv)
    if args.cmd == "convert":
        return cmd_convert(args) or 0
    return cmd_verify(args)


if __name__ == "__main__":
    sys.exit(main())
