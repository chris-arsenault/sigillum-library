#!/usr/bin/env python3
"""Audit MusicXML notation arithmetic and independent Verovio import locally.

Requires the optional public ``verovio`` Python package. No network calls or
hosted rendering. Checks per-part/per-measure written pitch order, visible
explicit accidentals and exact duration against MEI, including every chord
member and tie continuation. It does not claim playback, full implicit key
interpretation, or another notation
application's import semantics. Use XML/MIDI sounding parity alongside this.
"""

import argparse
from collections import Counter
from fractions import Fraction as F
import json
from pathlib import Path
import xml.etree.ElementTree as E

NS = {"m": "http://www.music-encoding.org/ns/mei"}
VALUES = {"breve": F(8), "whole": F(4), "half": F(2), "quarter": F(1),
          "eighth": F(1, 2), "16th": F(1, 4), "32nd": F(1, 8),
          "64th": F(1, 16), "128th": F(1, 32), "256th": F(1, 64),
          "512th": F(1, 128), "1024th": F(1, 256)}
ACCIDENTALS = {"sharp": "s", "flat": "f", "natural": "n", "double-sharp": "ss",
               "sharp-sharp": "ss", "flat-flat": "ff", "triple-sharp": "ts", "triple-flat": "tf"}


def xml_observations(root):
    notes, issues = {}, []
    grouped = ungrouped = 0
    staff_number = 0
    for part in root.findall("part"):
        # Multi-staff parts receive consecutive MEI staff numbers.
        staff_count = max([int(v.text) for v in part.findall(".//staves")] or [1])
        divisions = None
        for measure in part.findall("measure"):
            bar = measure.get("number")
            value = measure.findtext("attributes/divisions")
            if value:
                divisions = int(value)
            active = {}
            for staff in range(1, staff_count + 1):
                notes[(str(staff_number + staff), bar)] = []
            for note in measure.findall("note"):
                if note.find("grace") is not None:
                    issues.append(f"{part.get('id')} b{bar}: grace notes outside audit scope")
                    continue
                staff = int(note.findtext("staff", "1"))
                key = (str(staff_number + staff), bar)
                where = f"{part.get('id')} b{bar} note {len(notes[key]) + 1}"
                duration = F(int(note.findtext("duration")), divisions)
                pitch = note.find("pitch")
                unpitched = note.find("unpitched")
                if pitch is not None or unpitched is not None:
                    step = note.findtext("pitch/step") or note.findtext("unpitched/display-step")
                    octave = note.findtext("pitch/octave") or note.findtext("unpitched/display-octave")
                    notes[key].append((step.lower() if pitch is not None else None,
                                       octave if pitch is not None else None, str(duration),
                                       ACCIDENTALS.get(note.findtext("accidental"))))
                is_chord = note.find("chord") is not None
                if is_chord and note.findall("beam"):
                    issues.append(f"{where}: duplicate beam on secondary chord member")
                if note.find("rest[@measure='yes']") is not None:
                    continue
                base = VALUES.get(note.findtext("type"))
                if base is None:
                    issues.append(f"{where}: unsupported/missing note type")
                    continue
                written = base * (2 - F(1, 2 ** len(note.findall("dot"))))
                tm = note.find("time-modification")
                if tm is not None:
                    written *= F(int(tm.findtext("normal-notes")), int(tm.findtext("actual-notes")))
                if duration != written:
                    issues.append(f"{where}: duration {duration} != notation {written}")
                if is_chord:
                    continue
                voice = (staff, note.findtext("voice", "1"))
                for mark in note.findall("notations/tuplet[@type='start']"):
                    number = mark.get("number", "1")
                    active[(voice, number)] = [F(0), tm.findtext("normal-type") if tm is not None else None]
                groups = [value for (v, _), value in active.items() if v == voice]
                if tm is not None:
                    if groups:
                        grouped += 1
                    else:
                        ungrouped += 1
                        issues.append(f"{where}: time modification has no complete tuplet group")
                for value in groups:
                    value[0] += duration
                    if tm is not None and tm.findtext("normal-type") != value[1]:
                        issues.append(f"{where}: mixed normal-type inside group")
                for mark in note.findall("notations/tuplet[@type='stop']"):
                    value = active.pop((voice, mark.get("number", "1")), None)
                    if value is None or value[1] not in VALUES or value[0] != 2 * VALUES[value[1]]:
                        issues.append(f"{where}: incomplete triplet span {value}")
            if active:
                issues.append(f"{part.get('id')} b{bar}: unclosed tuplets")
        staff_number += staff_count
    return notes, issues, grouped, ungrouped


def mei_observations(root):
    notes = {}
    ppq = {v.get("n"): int(v.get("ppq")) for v in root.findall(".//m:staffDef", NS)}
    for measure in root.findall(".//m:measure", NS):
        for staff in measure.findall("m:staff", NS):
            key = (staff.get("n"), measure.get("n"))
            parents = {child: parent for parent in staff.iter() for child in parent}
            items = []
            for note in staff.findall(".//m:note", NS):
                parent = parents[note]
                duration = note.get("dur.ppq") or parent.get("dur.ppq")
                accidental = note.find("m:accid", NS)
                visible = note.get("accid") or (accidental.get("accid") if accidental is not None else None)
                items.append((note.get("pname") or note.get("ploc"),
                              note.get("oct") or note.get("oloc"),
                              str(F(int(duration), ppq[staff.get("n")])), visible))
            notes[key] = items
    return notes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--artifacts", type=Path, help="Local directory for report and MEI")
    parser.add_argument("--render-bars", help="Optional Verovio measure range, e.g. 76-77")
    args = parser.parse_args()
    import verovio
    verovio.enableLog(verovio.LOG_ERROR)
    expected, issues, grouped, ungrouped = xml_observations(E.parse(args.source).getroot())
    toolkit = verovio.toolkit()
    toolkit.setOptions({"breaks": "auto", "pageWidth": 2200, "pageHeight": 6000,
                        "adjustPageHeight": True})
    if not toolkit.loadFile(str(args.source)):
        raise RuntimeError("Verovio could not import the MusicXML")
    mei = toolkit.getMEI()
    observed = mei_observations(E.fromstring(mei))
    differences = {}
    for key in sorted(set(expected) | set(observed)):
        if expected.get(key, []) != observed.get(key, []):
            differences[f"staff {key[0]} b{key[1]}"] = {
                "xml": expected.get(key, []), "mei": observed.get(key, [])}
    report = {"source": str(args.source), "consumer": toolkit.getVersion(),
              "xml_noteheads": sum(map(len, expected.values())),
              "consumer_noteheads": sum(map(len, observed.values())),
              "part_measure_pairs": len(expected), "grouped_tuplet_events": grouped,
              "ungrouped_tuplet_events": ungrouped, "notation_issues": issues,
              "consumer_differences": differences,
              "counts_per_staff": dict(Counter({staff: sum(len(v) for (s, _), v in expected.items() if s == staff)
                                                for staff, _ in expected})),
              "counts_per_part_measure": {f"{s}:{b}": len(v) for (s, b), v in expected.items()}}
    if args.artifacts:
        args.artifacts.mkdir(parents=True, exist_ok=True)
        (args.artifacts / "import.mei").write_text(mei)
        (args.artifacts / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        if args.render_bars:
            toolkit.select({"measureRange": args.render_bars})
            toolkit.redoLayout()
            for page in range(1, toolkit.getPageCount() + 1):
                (args.artifacts / f"bars-{args.render_bars}-{page}.svg").write_text(toolkit.renderToSVG(page))
    summary = {k: v for k, v in report.items()
               if k not in ("counts_per_part_measure", "consumer_differences", "notation_issues")}
    summary.update(notation_issue_count=len(issues), notation_issues=issues[:12],
                   consumer_difference_count=len(differences),
                   consumer_differences=dict(list(differences.items())[:3]))
    print(json.dumps(summary, indent=2))
    return int(bool(issues or differences))


if __name__ == "__main__":
    raise SystemExit(main())
