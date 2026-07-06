import json
from pathlib import Path
import tempfile
import unittest
import xml.etree.ElementTree as ET

from music21 import chord, dynamics, expressions, instrument, meter, tempo

from framework.orchestral_dsl_transport import (
    build_score_from_transport,
    instrument_for_part,
    load_transport,
    part_items_from_transport,
    write_transport_score,
)


def sample_transport():
    return {
        "schema": "sigillum.orchestral_dsl.transport",
        "schema_version": 3,
        "source_model": "production_hybrid",
        "title": "Transport Test",
        "meter": "7/8",
        "beat_pattern": [3, 2, 2],
        "bar_length_ql": 3.5,
        "key": "F",
        "tempo_marks": ["eighth = 132"],
        "tempo_events": [{"offset_ql": 0.0, "bpm": 132, "text": "eighth = 132"}],
        "total_duration_ql": 7.0,
        "parts": [
            {"id": "clarinet", "name": "Clarinet", "music21_instrument": "Clarinet", "family": "woodwind"},
            {"id": "piano_upper", "name": "Piano Upper", "music21_instrument": "Piano", "family": "keyboard"},
            {"id": "cello", "name": "Violoncello", "music21_instrument": "Violoncello", "family": "string"},
            {"id": "hand_drum", "name": "Hand Drum", "music21_instrument": "Percussion", "family": "percussion"},
        ],
        "controls": [
            {
                "kind": "dynamic",
                "value": "mf",
                "target": {"type": "selector", "selector": "clarinet"},
                "offset_ql": 0.0,
            },
            {
                "kind": "crescendo",
                "target": {"type": "selector", "selector": "string"},
                "from_offset_ql": 0.0,
                "to_offset_ql": 3.5,
            },
            {
                "kind": "pedal",
                "value": "down",
                "target": {"type": "selector", "selector": "keyboard"},
                "offset_ql": 0.0,
            },
        ],
        "sections": [
            {
                "id": "s1",
                "name": "Opening",
                "bars": {"first": 1, "last": 2},
                "spans": [
                    {
                        "bars": {"first": 1, "last": 2},
                        "start_offset_ql": 0.0,
                        "end_offset_ql": 7.0,
                        "harmony": ["F home"],
                    }
                ],
            }
        ],
        "phrases": [],
        "placements": [],
        "timed_events": [
            {
                "part": "clarinet",
                "role": "foreground",
                "phrase_id": "call",
                "pitch": "C5",
                "pitches": ["C5"],
                "pitch_label": "C5",
                "event_type": "note",
                "rest": False,
                "duration_ql": 1.5,
                "offset_ql": 0.0,
                "end_offset_ql": 1.5,
                "offset_label": "b1:1",
                "local_marks": ["accent"],
            },
            {
                "part": "clarinet",
                "role": "foreground",
                "phrase_id": "call",
                "pitch": "Bb4",
                "pitches": ["Bb4"],
                "pitch_label": "Bb4",
                "event_type": "note",
                "rest": False,
                "duration_ql": 0.5,
                "offset_ql": 2.0,
                "end_offset_ql": 2.5,
                "offset_label": "b1:3",
            },
            {
                "part": "piano_upper",
                "role": "harmony",
                "phrase_id": "chord",
                "pitch": ["A3", "C4", "E4"],
                "pitches": ["A3", "C4", "E4"],
                "pitch_label": "[A3,C4,E4]",
                "event_type": "chord",
                "rest": False,
                "duration_ql": 2.0,
                "offset_ql": 0.0,
                "end_offset_ql": 2.0,
                "offset_label": "b1:1",
                "local_marks": ["mf", "txt:senza_ped."],
            },
            {
                "part": "cello",
                "role": "bass_line",
                "phrase_id": "bass",
                "pitch": "F2",
                "pitches": ["F2"],
                "pitch_label": "F2",
                "event_type": "note",
                "rest": False,
                "duration_ql": 3.5,
                "offset_ql": 0.0,
                "end_offset_ql": 3.5,
                "offset_label": "b1:1",
            },
        ],
        "staff_bars": [],
        "gestures": [],
    }


def technique_transport():
    """Two 4/4 bars exercising first-class playing-technique marks on both renderer
    paths: a grand-staff harp (notation_group) and a single-staff harp."""
    return {
        "schema": "sigillum.orchestral_dsl.transport",
        "schema_version": 3,
        "source_model": "production_hybrid",
        "title": "Technique Test",
        "meter": "4/4",
        "bar_length_ql": 4.0,
        "key": "C",
        "tempo_marks": ["quarter = 96"],
        "tempo_events": [{"offset_ql": 0.0, "bpm": 96, "text": "quarter = 96"}],
        "key_changes": [{"key": "F#", "at": "bar 2 beat 1", "offset_ql": 4.0}],
        "total_duration_ql": 8.0,
        "parts": [
            {
                "id": "harp_upper",
                "name": "Harp",
                "music21_instrument": "Harp",
                "family": "plucked",
                "notation_group": "harp",
                "notation_staff": "1",
            },
            {
                "id": "harp_lower",
                "name": "Harp",
                "music21_instrument": "Harp",
                "family": "plucked",
                "notation_group": "harp",
                "notation_staff": "2",
            },
            {"id": "solo_harp", "name": "Solo Harp", "music21_instrument": "Harp", "family": "plucked"},
        ],
        "controls": [
            {
                "kind": "harp_pedals",
                "value": "D#,C#,B#,E#,F#,G#,A#",
                "target": {"type": "selector", "selector": "harp_upper"},
                "offset_ql": 4.0,
            }
        ],
        "sections": [],
        "phrases": [],
        "placements": [],
        "timed_events": [
            # grand staff, upper: rolled chords up and down, then a glissando whose
            # landing note crosses the barline (split ties) and carries l.v.
            {"part": "harp_upper", "role": "foreground", "phrase_id": "u", "pitch": ["C4", "E4", "G4"],
             "pitches": ["C4", "E4", "G4"], "event_type": "chord", "rest": False,
             "duration_ql": 1.0, "offset_ql": 0.0, "local_marks": ["arp"]},
            {"part": "harp_upper", "role": "foreground", "phrase_id": "u", "pitch": ["A4", "C5", "E5"],
             "pitches": ["A4", "C5", "E5"], "event_type": "chord", "rest": False,
             "duration_ql": 1.0, "offset_ql": 1.0, "local_marks": ["arp:down"]},
            {"part": "harp_upper", "role": "foreground", "phrase_id": "u", "pitch": "E5",
             "pitches": ["E5"], "event_type": "note", "rest": False,
             "duration_ql": 1.0, "offset_ql": 2.0, "local_marks": ["gliss("]},
            {"part": "harp_upper", "role": "foreground", "phrase_id": "u", "pitch": "G5",
             "pitches": ["G5"], "event_type": "note", "rest": False,
             "duration_ql": 2.0, "offset_ql": 3.0, "local_marks": ["gliss)", "lv"]},
            # grand staff, lower: l.v. on an untied note = a real let-ring tie
            {"part": "harp_lower", "role": "bass", "phrase_id": "l", "pitch": "C3",
             "pitches": ["C3"], "event_type": "note", "rest": False,
             "duration_ql": 1.0, "offset_ql": 0.0, "local_marks": ["arp"]},
            {"part": "harp_lower", "role": "bass", "phrase_id": "l", "pitch": "D3",
             "pitches": ["D3"], "event_type": "note", "rest": False,
             "duration_ql": 3.0, "offset_ql": 1.0, "local_marks": ["lv"]},
            # single staff: the same vocabulary through mk_part
            {"part": "solo_harp", "role": "foreground", "phrase_id": "s", "pitch": ["D4", "F4", "A4"],
             "pitches": ["D4", "F4", "A4"], "event_type": "chord", "rest": False,
             "duration_ql": 2.0, "offset_ql": 0.0, "local_marks": ["arp:down"]},
            {"part": "solo_harp", "role": "foreground", "phrase_id": "s", "pitch": "A4",
             "pitches": ["A4"], "event_type": "note", "rest": False,
             "duration_ql": 2.0, "offset_ql": 2.0, "local_marks": ["gliss("]},
            {"part": "solo_harp", "role": "foreground", "phrase_id": "s", "pitch": "D5",
             "pitches": ["D5"], "event_type": "note", "rest": False,
             "duration_ql": 4.0, "offset_ql": 4.0, "local_marks": ["gliss)", "lv"]},
        ],
        "staff_bars": [],
        "gestures": [],
    }


def grand_staff_transport():
    data = sample_transport()
    data["parts"] = [
        {
            "id": "piano_upper",
            "name": "Piano Upper",
            "music21_instrument": "Piano",
            "family": "keyboard",
            "notation_group": "piano",
            "notation_staff": "1",
        },
        {
            "id": "piano_middle",
            "name": "Piano Middle",
            "music21_instrument": "Piano",
            "family": "keyboard",
            "notation_group": "piano",
            "notation_staff": "auto",
        },
        {
            "id": "piano_lower",
            "name": "Piano Lower",
            "music21_instrument": "Piano",
            "family": "keyboard",
            "notation_group": "piano",
            "notation_staff": "2",
        },
    ]
    data["controls"] = [
        {
            "kind": "pedal",
            "value": "down",
            "target": {"type": "selector", "selector": "keyboard"},
            "offset_ql": 0.0,
        },
        {
            "kind": "pedal",
            "value": "up",
            "target": {"type": "selector", "selector": "keyboard"},
            "offset_ql": 3.5,
        },
    ]
    data["sections"] = []
    data["timed_events"] = [
        {
            "part": "piano_upper",
            "role": "foreground",
            "phrase_id": "upper",
            "pitch": "C5",
            "pitches": ["C5"],
            "event_type": "note",
            "rest": False,
            "duration_ql": 3.5,
            "offset_ql": 0.0,
            "local_marks": ["mf"],
        },
        {
            "part": "piano_middle",
            "role": "harmony",
            "phrase_id": "middle",
            "pitch": ["A3", "E4"],
            "pitches": ["A3", "E4"],
            "event_type": "chord",
            "rest": False,
            "duration_ql": 3.5,
            "offset_ql": 0.0,
            "local_marks": ["mp"],
        },
        {
            "part": "piano_lower",
            "role": "bass",
            "phrase_id": "lower",
            "pitch": "A2",
            "pitches": ["A2"],
            "event_type": "note",
            "rest": False,
            "duration_ql": 3.5,
            "offset_ql": 0.0,
            "local_marks": ["mf"],
        },
    ]
    return data


class OrchestralDSLTransportTests(unittest.TestCase):
    def test_part_items_fill_gaps_and_trailing_rests(self):
        data = sample_transport()

        self.assertEqual(
            part_items_from_transport(data, "clarinet"),
            [("C5", 1.5, "accent"), (None, 0.5), ("Bb4", 0.5), (None, 4.5)],
        )
        self.assertEqual(
            part_items_from_transport(data, "piano_upper"),
            [(["A3", "C4", "E4"], 2.0, "mf", "txt:senza ped."), (None, 5.0)],
        )
        self.assertEqual(part_items_from_transport(data, "hand_drum"), [(None, 7.0)])

    def test_load_transport_rejects_old_schema_versions(self):
        data = sample_transport()
        data["schema_version"] = 2

        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "old.json"
            path.write_text(json.dumps(data))

            with self.assertRaisesRegex(ValueError, "unsupported orchestral DSL transport"):
                load_transport(path)

    def test_build_score_from_transport_uses_roster_and_omits_harmony_text(self):
        score = build_score_from_transport(sample_transport())

        self.assertEqual(len(score.parts), 4)
        self.assertEqual(score.parts[0].partName, "Clarinet")
        self.assertIsInstance(score.parts[1].getInstrument(), instrument.Piano)
        self.assertTrue(score.parts[1].recurse().getElementsByClass(chord.Chord))
        self.assertTrue(score.parts[1].recurse().getElementsByClass(expressions.PedalMark))
        self.assertTrue(score.parts[0].recurse().getElementsByClass(dynamics.Dynamic))
        # Span harmony strings are analysis for the source/projections, not score
        # text; chord labels in a rendered score come only from explicit `text`
        # controls. No part may carry a "harmony: ..." TextExpression.
        for part in score.parts:
            for item in part.recurse().getElementsByClass(expressions.TextExpression):
                self.assertFalse(item.content.startswith("harmony:"), item.content)

    def test_instrument_for_part_uses_explicit_music21_class(self):
        cases = [
            ("alto_flute", "Alto Flute", "Flute", instrument.Flute),
            ("flute", "Flute", "Flute", instrument.Flute),
            ("oboe", "Oboe", "Oboe", instrument.Oboe),
            ("english_horn", "English Horn", "EnglishHorn", instrument.EnglishHorn),
            ("clarinet", "Clarinet", "Clarinet", instrument.Clarinet),
            ("bass_clarinet", "Bass Clarinet", "BassClarinet", instrument.BassClarinet),
            ("bassoon", "Bassoon", "Bassoon", instrument.Bassoon),
            ("contrabassoon", "Contrabassoon", "Contrabassoon", instrument.Contrabassoon),
            ("horn_1_2", "Horn 1.2", "Horn", instrument.Horn),
            ("horn_3_4", "Horn 3.4", "Horn", instrument.Horn),
            ("trumpet_1", "Trumpet 1", "Trumpet", instrument.Trumpet),
            ("trumpets_2_3", "Trumpets 2.3", "Trumpet", instrument.Trumpet),
            ("trombones", "Trombones", "Trombone", instrument.Trombone),
            ("tuba", "Tuba", "Tuba", instrument.Tuba),
            ("timpani", "Timpani", "Timpani", instrument.Timpani),
            ("taiko", "Taiko", "Taiko", instrument.Taiko),
            ("snare_drum", "Snare Drum", "SnareDrum", instrument.SnareDrum),
            ("percussion", "Percussion", "Percussion", instrument.Percussion),
            ("harp", "Harp", "Harp", instrument.Harp),
            ("celesta", "Celesta", "Celesta", instrument.Celesta),
            ("organ", "Organ", "Organ", instrument.Organ),
            ("choir_upper", "Choir Upper", "Choir", instrument.Choir),
            ("choir_lower", "Choir Lower", "Choir", instrument.Choir),
            ("solo_violin", "Solo Violin", "Violin", instrument.Violin),
            ("violin_1", "Violin I", "Violin", instrument.Violin),
            ("violin_2", "Violin II", "Violin", instrument.Violin),
            ("viola", "Viola", "Viola", instrument.Viola),
            ("violoncello", "Violoncello", "Violoncello", instrument.Violoncello),
            ("contrabass", "Contrabass", "Contrabass", instrument.Contrabass),
        ]

        for part_id, name, class_name, expected in cases:
            with self.subTest(name=name):
                mapped = instrument_for_part({"id": part_id, "name": name, "music21_instrument": class_name})
                self.assertIsInstance(mapped, expected)
                self.assertEqual(mapped.instrumentName, name)

    def test_instrument_for_part_rejects_missing_or_unknown_music21_class(self):
        with self.assertRaises(KeyError):
            instrument_for_part({"id": "oboe", "name": "Oboe"})

        with self.assertRaisesRegex(ValueError, "unknown music21 instrument class"):
            instrument_for_part({"id": "oboe", "name": "Oboe", "music21_instrument": "NotAClass"})

    def test_build_score_from_transport_applies_meter_and_tempo_changes(self):
        data = sample_transport()
        data["meter"] = "4/4"
        data["bar_length_ql"] = 4.0
        data["total_duration_ql"] = 14.0
        data["meter_events"] = [
            {"bar": 1, "meter": "4/4", "bar_length_ql": 4.0, "offset_ql": 0.0},
            {"bar": 3, "meter": "3/4", "bar_length_ql": 3.0, "offset_ql": 8.0},
        ]
        data["tempo_events"] = [
            {"kind": "mark", "offset_ql": 0.0, "bpm": 72, "text": "quarter = 72"},
            {"kind": "mark", "offset_ql": 8.0, "bpm": 96, "text": "quarter = 96"},
        ]

        score = build_score_from_transport(data)

        signatures = [
            (float(sig.offset), sig.ratioString)
            for sig in score.parts[0].recurse().getElementsByClass(meter.TimeSignature)
        ]
        marks = [
            (float(mark.offset), mark.number)
            for mark in score.parts[0].recurse().getElementsByClass(tempo.MetronomeMark)
        ]
        self.assertIn((0.0, "4/4"), signatures)
        self.assertIn((8.0, "3/4"), signatures)
        self.assertIn((0.0, 72), marks)
        self.assertIn((8.0, 96), marks)

    def test_write_transport_score_writes_musicxml_and_midi(self):
        with tempfile.TemporaryDirectory() as tmp:
            paths = write_transport_score(sample_transport(), tmp, stem="transport_test")

            self.assertTrue(Path(paths["musicxml"]).exists())
            self.assertTrue(Path(paths["midi"]).exists())
            xml_text = Path(paths["musicxml"]).read_text()
            self.assertIn("<pedal", xml_text)
            self.assertNotIn("ped. down", xml_text)

    def test_grand_staff_notation_group_writes_one_musicxml_piano_part(self):
        with tempfile.TemporaryDirectory() as tmp:
            paths = write_transport_score(grand_staff_transport(), tmp, stem="grand_staff_test")

            xml_text = Path(paths["musicxml"]).read_text()
            self.assertEqual(xml_text.count("<score-part id="), 1)
            self.assertEqual(xml_text.count("<part id="), 1)
            self.assertIn("<part-name>Piano</part-name>", xml_text)
            self.assertIn("<staves>2</staves>", xml_text)
            self.assertIn("<staff>1</staff>", xml_text)
            self.assertIn("<staff>2</staff>", xml_text)
            self.assertIn("<backup>", xml_text)
            self.assertIn("<pedal", xml_text)
            root = ET.parse(paths["musicxml"]).getroot()
            for measure in root.findall(".//measure"):
                voice_staves = {}
                for xml_note in measure.findall("note"):
                    voice = xml_note.findtext("voice")
                    staff = xml_note.findtext("staff")
                    if voice and staff:
                        voice_staves.setdefault(voice, set()).add(staff)
                self.assertTrue(
                    all(len(staves) == 1 for staves in voice_staves.values()),
                    f"cross-staff voice reuse in measure {measure.get('number')}: {voice_staves}",
                )
                dynamic_locations = {}
                position = 0
                for child in measure:
                    if child.tag == "backup":
                        position -= int(child.findtext("duration") or 0)
                    elif child.tag == "forward":
                        position += int(child.findtext("duration") or 0)
                    elif child.tag == "note":
                        if child.find("chord") is None:
                            position += int(child.findtext("duration") or 0)
                    elif child.tag == "direction" and child.find("direction-type/dynamics") is not None:
                        offset = int(child.findtext("offset") or 0)
                        key = (child.findtext("staff"), position + offset)
                        dynamic_locations.setdefault(key, 0)
                        dynamic_locations[key] += 1
                self.assertTrue(
                    all(count == 1 for count in dynamic_locations.values()),
                    f"duplicate same-staff dynamics in measure {measure.get('number')}: {dynamic_locations}",
                )


    def test_playing_techniques_render_as_real_musicxml_notation(self):
        with tempfile.TemporaryDirectory() as tmp:
            paths = write_transport_score(technique_transport(), tmp, stem="technique_test")
            xml_text = Path(paths["musicxml"]).read_text()
            root = ET.parse(paths["musicxml"]).getroot()

            # techniques are notation elements, never txt-map text
            self.assertNotIn("txt:", xml_text)

            # rolled chords: <arpeggiate> on every chord member, up (plain) and down
            plain = [a for a in root.iter("arpeggiate") if a.get("direction") is None]
            down = [a for a in root.iter("arpeggiate") if a.get("direction") == "down"]
            # up-roll: 3 members (grand-staff upper) + 1 lower-staff C3
            self.assertEqual(len(plain), 4)
            # down-roll: 3 members grand staff + 3 members single staff
            self.assertEqual(len(down), 6)

            # glissandi: start/stop pairs with wavy line and gliss. label, on both paths
            starts = [g for g in root.iter("glissando") if g.get("type") == "start"]
            stops = [g for g in root.iter("glissando") if g.get("type") == "stop"]
            self.assertEqual(len(starts), 2)
            self.assertEqual(len(stops), 2)
            self.assertTrue(all(g.get("line-type") == "wavy" for g in starts + stops))
            self.assertTrue(all(g.text == "gliss." for g in starts))

            # l.v. on an untied note = a real let-ring tied element
            self.assertIn('<tied type="let-ring"', xml_text)

            # a mid-piece key change must land INSIDE measure 2 of the pre-measured
            # grand-staff part, not between measures where the writer drops it
            grand_measure_2 = root.find("part").find("measure[@number='2']")
            fifths = [k.findtext("fifths") for k in grand_measure_2.iter("key")]
            self.assertIn("6", fifths)

            # the harp_pedals control becomes a real <harp-pedals> diagram in measure 2
            # (placeholder words rewritten post-write), all seven strings sharped
            self.assertNotIn("harp-pedals:", xml_text)
            diagrams = list(grand_measure_2.iter("harp-pedals"))
            self.assertEqual(len(diagrams), 1)
            tunings = [(t.findtext("pedal-step"), t.findtext("pedal-alter"))
                       for t in diagrams[0].findall("pedal-tuning")]
            self.assertEqual(tunings, [(step, "1") for step in ["D", "C", "B", "E", "F", "G", "A"]])

    def test_grand_staff_event_crossing_barline_splits_into_tied_segments(self):
        with tempfile.TemporaryDirectory() as tmp:
            paths = write_transport_score(technique_transport(), tmp, stem="technique_split_test")
            root = ET.parse(paths["musicxml"]).getroot()

            # the grand-staff G5 (offset 3.0, 2 ql) must become two tied quarter notes
            grand_part = root.find("part")
            g5_notes = []
            for measure in grand_part.findall("measure"):
                for xml_note in measure.findall("note"):
                    pitch = xml_note.find("pitch")
                    if pitch is not None and pitch.findtext("step") == "G" and pitch.findtext("octave") == "5":
                        g5_notes.append((measure.get("number"), xml_note))
            self.assertEqual([number for number, _ in g5_notes], ["1", "2"])
            first, second = g5_notes[0][1], g5_notes[1][1]
            self.assertEqual(first.find("tie").get("type"), "start")
            self.assertEqual(second.find("tie").get("type"), "stop")

            # its lv falls back to the standard l.v. text because the tie slot is taken
            words = [w.text for w in root.iter("words")]
            self.assertIn("l.v.", words)

            # the glissando still lands on the attack segment (measure 1)
            measure_1 = grand_part.find("measure[@number='1']")
            self.assertTrue(
                any(g.get("type") == "stop" for g in measure_1.iter("glissando")),
                "glissando stop should attach to the first tied segment",
            )


if __name__ == "__main__":
    unittest.main()
