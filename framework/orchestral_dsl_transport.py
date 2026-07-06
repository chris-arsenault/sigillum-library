"""Render Sigillum orchestral DSL transport JSON through the existing music21 backend."""

from __future__ import annotations

import argparse
import copy
import json
import re
from pathlib import Path
from typing import Any

from music21 import chord as m21chord
from music21 import clef as m21clef
from music21 import tie as m21tie
from music21 import dynamics, expressions, instrument, key as m21key, layout, note, pitch, spanner, stream, tempo

from framework.foundation.aids import chord_symbol_or_text
from framework.foundation.exports import write_score_pair
from framework.foundation.score import apply_event_marks, mk_part, mk_score, new_mark_state

DYNAMIC_PRIORITY = {
    "ppp": 0,
    "pp": 1,
    "p": 2,
    "mp": 3,
    "mf": 4,
    "f": 5,
    "ff": 6,
    "fff": 7,
    "fp": 8,
    "sfz": 9,
}


def load_transport(path: str | Path) -> dict[str, Any]:
    data = json.loads(Path(path).read_text())
    schema = data.get("schema")
    version = data.get("schema_version")
    if schema != "sigillum.orchestral_dsl.transport" or version != 3:
        raise ValueError(f"unsupported orchestral DSL transport {schema!r} version {version!r}")
    return data


NOTES_PART_ID = "__notes__"


def needs_notes_part(data: dict[str, Any]) -> bool:
    """A dedicated bottom "Notes" staff is only worth adding if some free-text
    annotation control actually exists to put on it. Chord symbols are a distinct
    "chord_symbol" control kind (the DSL's `chord` builder) and never land here."""
    return any(control.get("kind") == "text" for control in data.get("controls") or [])


def build_score_from_transport(data: dict[str, Any]):
    total_ql = float(data.get("total_duration_ql", 0.0))
    if needs_notes_part(data):
        data = dict(data)
        data["parts"] = [
            *data.get("parts", []),
            {"id": NOTES_PART_ID, "name": "Notes", "music21_instrument": "Piano", "family": "notes"},
        ]
    parts, part_lookup, staff_groups, percussion_indexes = rendered_parts_from_transport(data, total_ql)

    score = mk_score(
        data["title"],
        data["meter"],
        data.get("key") or "C",
        parts,
        tempo_events(data),
        meter_events=meter_events(data),
    )
    for staff_group in staff_groups:
        score.insert(0, staff_group)
    attach_tempo_text(score, data)
    attach_controls(score, data, part_lookup)
    attach_key_changes(score, data)
    # must run after attach_key_changes: mid-piece key changes are applied to every
    # part indiscriminately, so these staves only end up keyless if this runs last.
    keyless_indexes = list(percussion_indexes)
    keyless_indexes.extend(part_lookup.get(NOTES_PART_ID, []))
    for index in keyless_indexes:
        strip_key_signature(score.parts[index])
    dedupe_simultaneous_dynamics(score)
    enforce_max_hairpin_length(score, data)
    return score


def dedupe_simultaneous_dynamics(score):
    """Collapse two-or-more Dynamic markings landing at the identical offset in one
    part down to one. Nothing in real notation stacks two dynamics on top of each
    other at the same instant — when it happens here it's always an authoring
    duplicate: a phrase's own embedded dynamic token (e.g. the "f" in "C4:1{f,marc}")
    colliding with a separate top-level `dynamic ..., at:` control landing on the same
    bar for the same part, or two dynamic tokens left on one note event by mistake.
    Keeps the last one at each offset, which is the control-attached one where a
    collision is control-vs-phrase (attach_controls runs after the phrase is built)."""
    for part in score.parts:
        by_offset: dict[float, list] = {}
        for d in part.recurse().getElementsByClass(dynamics.Dynamic):
            off = round(float(d.getOffsetInHierarchy(part)), 6)
            by_offset.setdefault(off, []).append(d)
        for group in by_offset.values():
            for d in group[:-1]:
                d.activeSite.remove(d)


# A printed hairpin reads as a single, immediate gesture; past a couple of bars the
# wedge just becomes a long diagonal line that's hard to read as one gesture, and
# real notation practice switches to a "poco a poco cresc./dim." marking instead.
# That marking must still be a real dynamics mark, not text standing in for one:
# music21's dynamics.Dynamic with a non-standard string exports as a genuine
# MusicXML <dynamics><other-dynamics> element carrying a real <sound dynamics="...">
# playback value — a specialized marking that actually affects the sound, same as
# "mf" or "ff" would, unlike expressions.TextExpression which is inert decoration.
# Hard cap: 2 bars (measured at the hairpin's own start, so it's correct across a
# meter change), no exceptions — applied uniformly regardless of which mechanism
# produced the wedge (a top-level `crescendo`/`diminuendo` control, or a phrase's
# own embedded "cresc(" ... "cresc)" pair).
MAX_HAIRPIN_BARS = 2


def enforce_max_hairpin_length(score, data: dict[str, Any]):
    for part in score.parts:
        for wedge in list(part.recurse().getElementsByClass((dynamics.Crescendo, dynamics.Diminuendo))):
            elements = list(wedge)
            if len(elements) < 2:
                continue
            start_offset = elements[0].getOffsetInHierarchy(part)
            end_offset = elements[-1].getOffsetInHierarchy(part)
            bar = bar_at_offset(data, start_offset)
            bar_length = bar["length"] if bar else 4.0
            if end_offset - start_offset <= MAX_HAIRPIN_BARS * bar_length:
                continue
            part.remove(wedge)
            label = "cresc. poco a poco" if isinstance(wedge, dynamics.Crescendo) else "dim. poco a poco"
            insert_at_part_offset(part, start_offset, dynamics.Dynamic(label))


def strip_key_signature(m21_part):
    """mk_score inserts the movement's tonal key signature into every part, but a
    key signature is meaningless on an unpitched percussion staff or the auxiliary
    Notes staff, and Dorico's own convention (confirmed against a Dorico-exported
    reference) is an explicit no-key marker: <key><fifths>0</fifths><mode>none</mode>
    </key>, not the surrounding key. Swap whatever key mk_score inserted for that."""
    for ks in list(m21_part.recurse().getElementsByClass(m21key.KeySignature)):
        ks.activeSite.remove(ks)
    no_key = m21key.KeySignature(0)
    no_key.mode = "none"
    m21_part.insert(0.0, no_key)


def rendered_parts_from_transport(data: dict[str, Any], total_ql: float):
    notation_groups = explicit_notation_groups(data)
    group_by_part = {
        part["id"]: group_name
        for group_name, group_parts in notation_groups.items()
        for part in group_parts
    }
    rendered_parts = []
    part_lookup: dict[str, list[int]] = {}
    staff_groups = []
    rendered_groups: set[str] = set()
    percussion_indexes: list[int] = []

    for part in data.get("parts", []):
        part_id = part["id"]
        group_name = group_by_part.get(part_id)
        if group_name:
            if group_name in rendered_groups:
                continue
            first_index = len(rendered_parts)
            upper, lower, staff_group = grand_staff_parts_from_transport(
                data,
                group_name,
                notation_groups[group_name],
            )
            rendered_parts.extend([upper, lower])
            staff_groups.append(staff_group)
            rendered_groups.add(group_name)
            for group_part in notation_groups[group_name]:
                indexes = notation_staff_indexes(group_part)
                part_lookup[group_part["id"]] = [first_index + index for index in indexes]
            continue

        if str(part.get("family") or "") == "notes":
            rendered = mk_part(part["name"], instrument_for_part(part), [(None, total_ql)], validate_ql=total_ql)
            rendered.partAbbreviation = "Notes"
            rendered_parts.append(rendered)
            part_lookup[part_id] = [len(rendered_parts) - 1]
            continue

        items = part_items_from_transport(data, part_id)
        rendered = mk_part(part["name"], instrument_for_part(part), items, validate_ql=total_ql)
        if str(part.get("family") or "") == "percussion":
            sound_classes = percussion_sound_map(part)
            if sound_classes:
                first_index = len(rendered_parts)
                split_parts = split_percussion_parts(rendered, part, sound_classes)
                rendered_parts.extend(split_parts)
                new_indexes = list(range(first_index, len(rendered_parts)))
                part_lookup[part_id] = new_indexes
                percussion_indexes.extend(new_indexes)
                if len(split_parts) > 1:
                    staff_groups.append(
                        layout.StaffGroup(
                            split_parts,
                            name=part.get("name") or "Percussion",
                            abbreviation=part.get("name") or "Perc.",
                            symbol="bracket",
                            barTogether=True,
                        )
                    )
                continue
        rendered_parts.append(rendered)
        part_lookup[part_id] = [len(rendered_parts) - 1]

    return rendered_parts, part_lookup, staff_groups, percussion_indexes


def explicit_notation_groups(data: dict[str, Any]):
    groups: dict[str, list[dict[str, Any]]] = {}
    for part in data.get("parts", []):
        group_name = part.get("notation_group")
        if group_name:
            groups.setdefault(str(group_name), []).append(part)
    return {
        group_name: group_parts
        for group_name, group_parts in groups.items()
        if len(group_parts) >= 2 and has_grand_staff_members(group_parts)
    }


def has_grand_staff_members(parts: list[dict[str, Any]]):
    staffs = {normalize_notation_staff(part.get("notation_staff")) for part in parts}
    return 1 in staffs and 2 in staffs


def grand_staff_parts_from_transport(data: dict[str, Any], group_name: str, parts: list[dict[str, Any]]):
    display_name = grand_staff_display_name(group_name, parts)
    safe_group = slug(group_name)
    upper = stream.PartStaff(id=f"{safe_group}_staff_1")
    lower = stream.PartStaff(id=f"{safe_group}_staff_2")
    for staff in (upper, lower):
        staff.partName = display_name
        staff.partAbbreviation = "Pno." if display_name.lower() == "piano" else display_name
        group_part = dict(parts[0])
        group_part["name"] = display_name
        staff.insert(0, instrument_for_part(group_part))
    # explicit grand-staff clefs: without them MusicXML defaults BOTH staves to treble
    # (the Dorico reference declares G2/F4 the same way)
    upper.insert(0, m21clef.TrebleClef())
    lower.insert(0, m21clef.BassClef())

    upper_measures = staff_measures(upper, data)
    lower_measures = staff_measures(lower, data)
    mark_state = {
        1: {**new_mark_state(), "dynamics": {}},
        2: {**new_mark_state(), "dynamics": {}},
    }
    events_by_part = timed_events_by_part(data)
    for part in parts:
        for event in events_by_part.get(part["id"], []):
            for staff_number, pitches in grand_staff_event_pitches(part, event):
                target = upper if staff_number == 1 else lower
                measures = upper_measures if staff_number == 1 else lower_measures
                voice_id = grand_staff_voice_id(part, staff_number)
                add_event_to_staff(target, measures, voice_id, event, pitches, mark_state[staff_number], data)

    staff_group = layout.StaffGroup(
        [upper, lower],
        name=display_name,
        abbreviation="Pno." if display_name.lower() == "piano" else display_name,
        symbol="brace",
        barTogether=True,
    )
    return upper, lower, staff_group


def staff_measures(staff, data: dict[str, Any]):
    measures = []
    for bar in bar_layout(data):
        measure = stream.Measure(number=bar["number"])
        staff.insert(bar["start"], measure)
        measures.append(measure)
    return measures


def timed_events_by_part(data: dict[str, Any]):
    grouped: dict[str, list[dict[str, Any]]] = {}
    for event in data.get("timed_events") or []:
        grouped.setdefault(event.get("part"), []).append(event)
    for events in grouped.values():
        events.sort(key=lambda event: (float(event.get("offset_ql", 0.0)), float(event.get("duration_ql", 0.0))))
    return grouped


def grand_staff_display_name(group_name: str, parts: list[dict[str, Any]]):
    if any("piano" in str(part.get("name", "")).lower() for part in parts):
        return "Piano"
    return str(group_name).replace("_", " ").title()


def notation_staff_indexes(part: dict[str, Any]):
    staff = normalize_notation_staff(part.get("notation_staff"))
    if staff == 2:
        return [1]
    if staff == "auto":
        return [0, 1]
    return [0]


def normalize_notation_staff(value):
    if str(value).strip().lower() in {"2", "lower", "bass", "left", "lh"}:
        return 2
    if str(value).strip().lower() in {"auto", "split"}:
        return "auto"
    return 1


def grand_staff_event_pitches(part: dict[str, Any], event: dict[str, Any]):
    pitches = event_pitches(event)
    if not pitches:
        staff = normalize_notation_staff(part.get("notation_staff"))
        if staff == "auto":
            return []
        return [(staff, [])]
    staff = normalize_notation_staff(part.get("notation_staff"))
    if staff == 2:
        return [(2, pitches)]
    if staff == "auto":
        staff = 2 if min(pitch.Pitch(value).midi for value in pitches) < 60 else 1
        return [(staff, pitches)]
    return [(1, pitches)]


def grand_staff_voice_id(part: dict[str, Any], staff_number: int):
    staff = normalize_notation_staff(part.get("notation_staff"))
    if staff == "auto":
        return 2 if staff_number == 1 else 3
    return 1 if staff_number == 1 else 4


def add_event_to_staff(
    staff,
    measures,
    voice_id: int,
    event: dict[str, Any],
    pitches: list[str],
    mark_state: dict[str, Any],
    data: dict[str, Any],
):
    duration = float(event.get("duration_ql", 0.0))
    offset = float(event.get("offset_ql", 0.0))
    segments = event_bar_segments(data, offset, duration, bar_count=len(measures))
    if not segments:
        return

    elements = []
    for _bar_number, _local_offset, seg_duration in segments:
        if not pitches:
            element = note.Rest(quarterLength=seg_duration)
        elif len(pitches) == 1:
            element = note.Note(pitches[0], quarterLength=seg_duration)
        else:
            element = m21chord.Chord(pitches, quarterLength=seg_duration)
        elements.append(element)
    if pitches and len(elements) > 1:
        # a note crossing barlines is engraved as tied per-bar segments; the tie is
        # set BEFORE marks apply so "lv" sees it and falls back to "l.v." text
        elements[0].tie = m21tie.Tie("start")
        for element in elements[1:-1]:
            element.tie = m21tie.Tie("continue")
        elements[-1].tie = m21tie.Tie("stop")

    # all marks attach at the event's attack (the first segment): point objects at its
    # offset, spanner endpoints on its element, articulations on its notehead
    first_bar, first_offset, _ = segments[0]
    first_measure = measures[first_bar - 1]

    def insert_point(obj):
        if isinstance(obj, dynamics.Dynamic):
            insert_staff_dynamic(first_measure, first_offset, obj, mark_state)
        else:
            first_measure.insert(first_offset, obj)

    marks = [_normalize_mark(mark) for mark in event.get("local_marks") or []]
    apply_event_marks(elements[0], marks, mark_state, insert_point, lambda sp: staff.insert(0, sp))

    for element, (bar_number, local_offset, _seg_duration) in zip(elements, segments):
        measure_voice(measures[bar_number - 1], voice_id).insert(local_offset, element)


def event_bar_segments(data: dict[str, Any], offset: float, duration: float, bar_count: int):
    """Split [offset, offset+duration) at barlines into (bar_number, local_offset,
    segment_duration) pieces. Returns [] when the event falls outside the laid-out bars."""
    segments = []
    cursor = offset
    remaining = duration
    while True:
        bar = bar_at_offset(data, cursor)
        if bar is None or bar["number"] < 1 or bar["number"] > bar_count:
            return []
        local_offset = cursor - bar["start"]
        seg_duration = min(remaining, bar["length"] - local_offset)
        segments.append((bar["number"], local_offset, seg_duration))
        remaining -= seg_duration
        cursor += seg_duration
        if remaining <= 1e-6:
            return segments


def measure_voice(measure, voice_id: int):
    for voice in measure.voices:
        if voice.id == voice_id:
            return voice
    voice = stream.Voice(id=voice_id)
    measure.insert(0, voice)
    return voice


def insert_staff_dynamic(measure, offset: float, dynamic, mark_state: dict[str, Any]):
    """Insert one Dynamic per (measure, offset), keeping the dominant of colliding marks
    (two grand-staff voices can land dynamics on the same beat)."""
    registry = mark_state.setdefault("dynamics", {})
    key = (measure.number, round(offset, 6))
    current = registry.get(key)
    if current is None:
        measure.insert(offset, dynamic)
        registry[key] = (dynamic.value, dynamic)
        return

    current_mark, current_dynamic = current
    chosen = dominant_dynamic(current_mark, dynamic.value)
    if chosen == current_mark:
        return

    measure.remove(current_dynamic)
    measure.insert(offset, dynamic)
    registry[key] = (chosen, dynamic)


def dominant_dynamic(left: str, right: str):
    left_rank = DYNAMIC_PRIORITY.get(left, -1)
    right_rank = DYNAMIC_PRIORITY.get(right, -1)
    return right if right_rank > left_rank else left


def part_items_from_transport(data: dict[str, Any], part_id: str):
    total_ql = float(data.get("total_duration_ql", 0.0))
    events = sorted(
        (event for event in data.get("timed_events", []) if event.get("part") == part_id),
        key=lambda event: (float(event["offset_ql"]), float(event["duration_ql"])),
    )

    current = 0.0
    items = []
    for event in events:
        offset = float(event["offset_ql"])
        duration = float(event["duration_ql"])
        if offset < current - 1e-6:
            raise ValueError(
                f"overlapping events in part {part_id}: "
                f"{event.get('phrase_id')} starts at {offset} before {current}"
            )
        if offset > current + 1e-6:
            items.append((None, round(offset - current, 6)))
        pitches = event_pitches(event)
        item_pitch = None if not pitches else pitches[0] if len(pitches) == 1 else pitches
        marks = [_normalize_mark(mark) for mark in event.get("local_marks") or []]
        items.append((item_pitch, duration, *marks))
        current = offset + duration

    if total_ql > current + 1e-6:
        items.append((None, round(total_ql - current, 6)))
    return items


def instrument_for_part(part: dict[str, Any]):
    class_name = str(part["music21_instrument"])
    cls = getattr(instrument, class_name, None)
    if cls is None or not isinstance(cls, type) or not issubclass(cls, instrument.Instrument):
        raise ValueError(f"unknown music21 instrument class {class_name!r} for part {part.get('id')!r}")

    inst = cls()
    inst.instrumentName = part.get("name") or part.get("id") or inst.instrumentName
    return inst


# Percussion-sound lexicon for roster descriptions such as
# "single staff: C3 snare, F2 bass drum, G3 cymbal". Each entry maps a
# description keyword to a music21 percussion instrument with a General MIDI
# drum-map pitch, so exports carry real unpitched percussion instead of
# pitched notes on a generic staff.
PERCUSSION_SOUND_CLASSES = (
    ("bass drum", instrument.BassDrum),
    ("snare", instrument.SnareDrum),
    ("hi-hat", instrument.HiHatCymbal),
    ("ride", instrument.RideCymbals),
    ("cymbal", instrument.CrashCymbals),
    ("tom", instrument.TomTom),
    ("triangle", instrument.Triangle),
    ("tambourine", instrument.Tambourine),
    ("woodblock", instrument.Woodblock),
)
def percussion_sound_map(part: dict[str, Any]):
    """Parse '<pitch> <sound-name>' pairs out of the roster description.

    Only parts that declare a staff-position convention (e.g. "C3 snare,
    F2 bass drum, G3 cymbal") are converted; pitched percussion (timpani,
    glockenspiel, ...) and single-sound parts without pitch positions return
    an empty map and are exported unchanged.
    """
    mapping: dict[tuple[str, int], type] = {}
    for step, octave, name in re.findall(
        r"([A-G])(\d)\s+([a-z][a-z -]*)", str(part.get("description") or "")
    ):
        for keyword, cls in PERCUSSION_SOUND_CLASSES:
            if keyword in name:
                mapping[(step, int(octave))] = cls
                break
    return mapping


def split_percussion_parts(m21_part, part: dict[str, Any], sound_classes):
    """Split one multi-sound percussion staff into one single-instrument part per
    kit piece actually used (e.g. Snare Drum / Bass Drum / Crash Cymbals), each on
    its own line, bracketed together.

    A single staff carrying several unpitched instruments sharing one staff
    (differentiated only by written pitch, tagged via per-note <instrument> refs) is
    the textbook-correct MusicXML shape — verified structurally against a Dorico
    6.2-exported reference file (multiple score-instruments, instrument-sound, a
    1-line percussion staff, no key signature) — but repeated real-world testing
    against actual Dorico import still collapsed it to one generic sound. A part
    with exactly one instrument and one clef has nothing left to guess, so it's the
    reliable shape when the shared-kit shape doesn't survive import in practice.
    """
    class_first_offset: dict[type, float] = {}
    for old in m21_part.recurse().notes:
        if not isinstance(old, note.Note):
            continue
        cls = sound_classes.get((old.pitch.step, old.pitch.octave), instrument.SnareDrum)
        offset = old.getOffsetInHierarchy(m21_part)
        if cls not in class_first_offset or offset < class_first_offset[cls]:
            class_first_offset[cls] = offset
    ordered_classes = sorted(class_first_offset, key=class_first_offset.get)

    split_parts = []
    for cls in ordered_classes:
        piece = copy.deepcopy(m21_part)
        inst = cls()
        inst.midiChannel = 9
        replacements = {}
        for old in list(piece.recurse().notes):
            if not isinstance(old, note.Note):
                continue
            note_cls = sound_classes.get((old.pitch.step, old.pitch.octave), instrument.SnareDrum)
            if note_cls is cls:
                drum = note.Unpitched()
                drum.displayStep = old.pitch.step
                drum.displayOctave = old.pitch.octave
                drum.duration = old.duration
                drum.articulations = old.articulations
                drum.expressions = old.expressions
                drum.tie = old.tie
                drum.notehead = old.notehead
                drum.lyrics = old.lyrics
                drum.storedInstrument = inst
                old.activeSite.replace(old, drum)
                replacements[old] = drum
            else:
                rest = note.Rest()
                rest.duration = old.duration
                old.activeSite.replace(old, rest)
                replacements[old] = rest
        # spanners (wedges, slurs) still reference the replaced Note objects;
        # re-anchor them, and drop any spanner left with no sounding member
        # (e.g. a wedge whose notes all became rests in this kit piece).
        for sp in list(piece.recurse().getElementsByClass(spanner.Spanner)):
            for old, new in replacements.items():
                if sp.hasSpannedElement(old):
                    sp.replaceSpannedElement(old, new)
            if not any(isinstance(el, (note.Unpitched, note.Note, m21chord.Chord))
                       for el in sp.getSpannedElements()):
                sp.activeSite.remove(sp)
        for existing in list(piece.recurse().getElementsByClass(instrument.Instrument)):
            existing.activeSite.remove(existing)
        piece.insert(0.0, inst)
        piece.insert(0.0, m21clef.PercussionClef())
        piece.insert(0.0, layout.StaffLayout(staffLines=1))
        piece.partName = inst.instrumentName
        piece.partAbbreviation = inst.instrumentAbbreviation
        split_parts.append(piece)
    return split_parts


# music21's MusicXML writer never emits <instrument-sound> (a literal "# TODO:
# instrument-sound" sits in instrumentToXmlScoreInstrument), even though every
# instrument.Instrument subclass carries the right value on .instrumentSound. Dorico's
# own import matches each <score-instrument> using "the name of the part... and the
# sound ID that describes what sound the instrument makes" (per Steinberg dev reply);
# without a sound ID, a multi-sound percussion kit collapses to one generic percussion
# voice on import instead of staying split into its snare/bass-drum/cymbal pieces. music21
# also assigns each kit instrument its own MIDI channel (correct for real instruments,
# wrong for a drum kit: GM percussion is one shared channel 10, disambiguated by note
# number) whenever two kit pieces claim the same requested channel. Both are repaired
# here as a post-write patch over the serialized XML, mirroring sanitize_musicxml_kinds.
_SCORE_INSTRUMENT_RE = re.compile(r"(<score-instrument\b[^>]*>)(.*?)(</score-instrument>)", re.S)
_INSTRUMENT_NAME_RE = re.compile(r"<instrument-name>([^<]*)</instrument-name>")
_MIDI_INSTRUMENT_RE = re.compile(r"(<midi-instrument\b[^>]*>)(.*?)(</midi-instrument>)", re.S)
_MIDI_CHANNEL_RE = re.compile(r"(<midi-channel>)\d+(</midi-channel>)")

GM_PERCUSSION_MIDI_CHANNEL = 10


def percussion_instrument_sounds() -> dict[str, str]:
    """Map each percussion instrument-name (as music21 renders it) to its MusicXML
    Standard Sounds id, e.g. "Snare Drum" -> "drum.snare-drum". Sourced by instantiating
    the classes in PERCUSSION_SOUND_CLASSES so the map can't drift from what
    split_percussion_parts actually inserts."""
    sounds = {}
    for _keyword, cls in PERCUSSION_SOUND_CLASSES:
        inst = cls()
        if inst.instrumentName and inst.instrumentSound:
            sounds[inst.instrumentName] = inst.instrumentSound
    return sounds


def sanitize_musicxml_percussion(xml_path):
    """Repair the two music21 percussion-export gaps described above, in place.

    Returns (sounds_added, channels_fixed).
    """
    p = Path(xml_path)
    try:
        text = p.read_text()
    except OSError:
        return 0, 0
    name_to_sound = percussion_instrument_sounds()
    sounds_added = 0

    def _fix_score_instrument(m):
        nonlocal sounds_added
        open_tag, body, close_tag = m.group(1), m.group(2), m.group(3)
        if "<instrument-sound>" in body:
            return m.group(0)
        name_match = _INSTRUMENT_NAME_RE.search(body)
        if not name_match:
            return m.group(0)
        sound = name_to_sound.get(name_match.group(1))
        if not sound:
            return m.group(0)
        sounds_added += 1
        trailing_ws = re.search(r"\s*\Z", body).group()
        indent = trailing_ws.rsplit("\n", 1)[-1] + "  " if "\n" in trailing_ws else "  "
        body_trimmed = body[: len(body) - len(trailing_ws)]
        return (
            f"{open_tag}{body_trimmed}\n{indent}<instrument-sound>{sound}</instrument-sound>"
            f"{trailing_ws}{close_tag}"
        )

    text = _SCORE_INSTRUMENT_RE.sub(_fix_score_instrument, text)

    channels_fixed = 0

    def _fix_midi_instrument(m):
        nonlocal channels_fixed
        open_tag, body, close_tag = m.group(1), m.group(2), m.group(3)
        if "<midi-unpitched>" not in body:
            return m.group(0)
        new_body, n = _MIDI_CHANNEL_RE.subn(
            rf"\g<1>{GM_PERCUSSION_MIDI_CHANNEL}\g<2>", body
        )
        if n:
            channels_fixed += 1
        return f"{open_tag}{new_body}{close_tag}"

    text = _MIDI_INSTRUMENT_RE.sub(_fix_midi_instrument, text)

    if sounds_added or channels_fixed:
        p.write_text(text)
    return sounds_added, channels_fixed


def tempo_events(data: dict[str, Any]):
    events = []
    for event in data.get("tempo_events") or []:
        if event.get("kind") not in (None, "mark"):
            continue
        bpm = event.get("bpm")
        if bpm is not None:
            events.append((float(event.get("offset_ql", 0.0)), float(bpm)))
    return events or [(0.0, 120.0)]


def meter_events(data: dict[str, Any]):
    events = []
    for event in data.get("meter_events") or []:
        meter_text = event.get("meter")
        if meter_text:
            events.append((float(event.get("offset_ql", 0.0)), str(meter_text)))
    return sorted(events) or None


def bar_layout(data: dict[str, Any]):
    total_ql = float(data.get("total_duration_ql", 0.0))
    if total_ql <= 0:
        return [{"number": 1, "start": 0.0, "length": float(data.get("bar_length_ql") or 4.0)}]

    changes = sorted(
        (
            {
                "offset": float(event.get("offset_ql", 0.0)),
                "length": float(event.get("bar_length_ql") or data.get("bar_length_ql") or 4.0),
            }
            for event in data.get("meter_events") or []
            if event.get("meter")
        ),
        key=lambda event: event["offset"],
    )
    if not changes or changes[0]["offset"] > 1e-6:
        changes.insert(0, {"offset": 0.0, "length": float(data.get("bar_length_ql") or 4.0)})

    layout = []
    current_change = 0
    current_length = changes[0]["length"]
    start = 0.0
    number = 1
    while start < total_ql - 1e-6:
        while current_change + 1 < len(changes) and abs(changes[current_change + 1]["offset"] - start) < 1e-6:
            current_change += 1
            current_length = changes[current_change]["length"]
        layout.append({"number": number, "start": start, "length": current_length})
        start = round(start + current_length, 10)
        number += 1
    return layout


def bar_at_offset(data: dict[str, Any], offset: float):
    for bar in bar_layout(data):
        if bar["start"] <= offset < bar["start"] + bar["length"] - 1e-6:
            return bar
    layout = bar_layout(data)
    if layout and abs(offset - (layout[-1]["start"] + layout[-1]["length"])) < 1e-6:
        return layout[-1]
    return None


def event_pitches(event: dict[str, Any]) -> list[str]:
    if "pitches" in event:
        return [str(pitch) for pitch in event.get("pitches") or []]
    if event.get("rest"):
        return []
    pitch = event.get("pitch")
    if pitch is None:
        return []
    if isinstance(pitch, list):
        return [str(member) for member in pitch]
    return [str(pitch)]


def attach_tempo_text(score, data: dict[str, Any]):
    if not score.parts:
        return
    first_part = score.parts[0]
    marks = sorted(tempo_events(data))
    for event in data.get("tempo_events") or []:
        kind = event.get("kind")
        if kind == "mark":
            continue
        if kind in {"ritardando", "accelerando"}:
            offset = float(event.get("from_offset_ql", 0.0))
            to_offset = float(event.get("to_offset_ql", offset))
            label = event.get("text") or {"ritardando": "rit.", "accelerando": "accel."}[kind]
            attach_tempo_ramp(first_part, marks, kind, offset, to_offset)
        elif kind == "a_tempo":
            offset = float(event.get("offset_ql", 0.0))
            label = event.get("text") or "a tempo"
        else:
            continue
        text = expressions.TextExpression(label)
        text.style.fontStyle = "italic"
        insert_at_part_offset(first_part, offset, text)


# accelerando/ritardando are notated as one static "accel."/"rit." text plus, wherever
# the DSL happens to be silent about the endpoint, a fallback percentage — but every
# such gesture in practice is already bracketed by explicit "mark" tempo events (the
# governing tempo right before it, the resolved tempo at/after it), so the real target
# is normally read straight off the next mark, not guessed. This ramp exists purely
# for audible correctness: on the page nothing changes beyond the existing text and
# whatever mark already prints as a real tempo number, since every ramp step's number
# is marked implicit (hidden) — only its <sound tempo="..."> survives to MusicXML.
DEFAULT_TEMPO_RAMP_PERCENT = {"accelerando": 125.0, "ritardando": 65.0}
TEMPO_RAMP_STEP_QL = 1.0


def attach_tempo_ramp(part, marks: list[tuple[float, float]], kind: str, from_offset: float, to_offset: float):
    span = to_offset - from_offset
    if span <= 0:
        return
    base_bpm = bpm_at_or_before(marks, from_offset)
    target_bpm = bpm_at_or_after(marks, to_offset)
    if target_bpm is None:
        target_bpm = base_bpm * DEFAULT_TEMPO_RAMP_PERCENT[kind] / 100.0

    steps = max(1, round(span / TEMPO_RAMP_STEP_QL))
    for i in range(1, steps + 1):
        offset = from_offset + span * i / steps
        bpm = base_bpm + (target_bpm - base_bpm) * i / steps
        mm = tempo.MetronomeMark(number=round(bpm, 2))
        mm.numberImplicit = True
        insert_at_part_offset(part, offset, mm)


def bpm_at_or_before(marks: list[tuple[float, float]], offset: float) -> float:
    result = marks[0][1] if marks else 120.0
    for mark_offset, bpm in marks:
        if mark_offset <= offset + 1e-6:
            result = bpm
        else:
            break
    return result


def bpm_at_or_after(marks: list[tuple[float, float]], offset: float) -> float | None:
    for mark_offset, bpm in marks:
        if mark_offset >= offset - 1e-6:
            return bpm
    return None


def attach_controls(score, data: dict[str, Any], part_lookup: dict[str, list[int]] | None = None):
    part_lookup = part_lookup or {part.get("id"): [idx] for idx, part in enumerate(data.get("parts", []))}
    controls = data.get("controls") or []
    notes_index = part_lookup.get(NOTES_PART_ID)
    notes_part = score.parts[notes_index[0]] if notes_index else None
    for control in controls:
        kind = control.get("kind")
        if kind == "pedal":
            continue
        if kind == "chord_symbol":
            attach_chord_symbol_control(score, control)
            continue
        if kind == "harp_pedals":
            attach_harp_pedals_control(score, data, control, part_lookup)
            continue
        if kind == "text":
            attach_text_control(notes_part, control)
            continue
        for part in target_parts(score, data, control.get("target") or {}, part_lookup):
            attach_control_to_part(part, control)
    attach_pedal_controls(score, data, controls, part_lookup)


def attach_chord_symbol_control(score, control: dict[str, Any]):
    """The DSL's `chord` builder ("kind": "chord_symbol") is a distinct control type
    from `text`, chosen by the composer at authoring time — never inferred from what
    the string looks like. Always goes once, as real harmony, on the top staff."""
    if not score.parts:
        return
    value = str(control.get("value") or "")
    offset = float(control.get("offset_ql", 0.0))
    insert_at_part_offset(score.parts[0], offset, chord_symbol_or_text(value))


def attach_harp_pedals_control(score, data: dict[str, Any], control: dict[str, Any], part_lookup: dict[str, list[int]]):
    """A harp pedal diagram (the DSL's `harp_pedals` builder). music21 has no object for
    the MusicXML <harp-pedals> element, so the setting travels as a "harp-pedals:D,C,B,..."
    words placeholder at the right offset on the target's top staff; exports.py's
    sanitize_musicxml_harp_pedals rewrites it into the real element after serialization."""
    parts = target_parts(score, data, control.get("target") or {}, part_lookup)
    if not parts:
        return
    placeholder = expressions.TextExpression(f"harp-pedals:{control.get('value')}")
    insert_at_part_offset(parts[0], float(control.get("offset_ql", 0.0)), placeholder)


def attach_text_control(notes_part, control: dict[str, Any]):
    """Free-form prose commentary (the DSL's `text` builder) goes once on the
    dedicated bottom Notes staff, not pasted onto every targeted instrument's own
    staff."""
    if notes_part is None:
        return
    value = str(control.get("value") or "")
    offset = float(control.get("offset_ql", 0.0))
    text = expressions.TextExpression(value)
    text.style.fontStyle = "italic"
    notes_part.insert(offset, text)


def attach_key_changes(score, data: dict[str, Any]):
    key_changes = data.get("key_changes") or []
    if not key_changes:
        return
    for kc in sorted(key_changes, key=lambda k: float(k.get("offset_ql", 0.0))):
        offset = float(kc["offset_ql"])
        for part in score.parts:
            insert_at_part_offset(part, offset, m21key.Key(kc["key"]))


def insert_at_part_offset(part, offset: float, obj):
    """Insert obj at a part-level offset. Flat mk_part parts take a plain insert, but on
    pre-measured parts (the grand-staff assembler) a part-level insert lands BETWEEN the
    measures where the MusicXML writer never looks — route into the containing measure."""
    containing = None
    for measure in part.getElementsByClass(stream.Measure):
        if float(measure.offset) <= offset + 1e-6:
            containing = measure
        else:
            break
    if containing is not None:
        containing.insert(max(0.0, offset - float(containing.offset)), obj)
    else:
        part.insert(offset, obj)


def target_parts(score, data: dict[str, Any], target: dict[str, Any], part_lookup: dict[str, list[int]]):
    selectors: list[str]
    target_type = target.get("type")
    if target_type == "all":
        return list(score.parts)
    if target_type == "list":
        selectors = [str(selector) for selector in target.get("selectors") or []]
    else:
        selectors = [str(target.get("selector"))]

    matched = []
    for selector in selectors:
        for idx in matching_part_indexes(data, selector, part_lookup):
            if idx < len(score.parts) and score.parts[idx] not in matched:
                matched.append(score.parts[idx])
    return matched


def matching_part_indexes(data: dict[str, Any], selector: str, part_lookup: dict[str, list[int]]):
    if selector in part_lookup:
        return part_lookup[selector]

    indexes = []
    for part in data.get("parts", []):
        if selector in {str(part.get("family")), str(part.get("name")), str(part.get("id"))}:
            for idx in part_lookup.get(part.get("id"), []):
                if idx not in indexes:
                    indexes.append(idx)
    if indexes:
        return indexes

    role_indexes = []
    for event in data.get("timed_events", []):
        if event.get("role") == selector and event.get("part") in part_lookup:
            for idx in part_lookup[event.get("part")]:
                if idx not in role_indexes:
                    role_indexes.append(idx)
    return role_indexes


def attach_control_to_part(part, control: dict[str, Any]):
    kind = control.get("kind")
    if kind == "dynamic":
        value = control.get("value")
        if value:
            insert_at_part_offset(part, float(control.get("offset_ql", 0.0)), dynamics.Dynamic(str(value)))
    elif kind in {"crescendo", "diminuendo"}:
        attach_hairpin(part, kind, float(control.get("from_offset_ql", 0.0)), float(control.get("to_offset_ql", 0.0)))


def attach_pedal_controls(score, data: dict[str, Any], controls: list[dict[str, Any]], part_lookup: dict[str, list[int]]):
    per_part: dict[int, tuple[Any, list[dict[str, Any]]]] = {}
    for control in controls:
        if control.get("kind") != "pedal":
            continue
        matched_parts = target_parts(score, data, control.get("target") or {}, part_lookup)
        for part in pedal_target_parts(matched_parts):
            _, part_controls = per_part.setdefault(id(part), (part, []))
            part_controls.append(control)

    total_ql = float(data.get("total_duration_ql", 0.0))
    for part, part_controls in per_part.values():
        attach_pedal_sequence(part, part_controls, total_ql)


def pedal_target_parts(parts):
    if len(parts) <= 1:
        return parts
    piano_parts = [part for part in parts if "piano" in str(part.partName or "").lower()]
    if len(piano_parts) == len(parts):
        return [piano_parts[-1]]
    return parts


def attach_pedal_sequence(part, controls: list[dict[str, Any]], total_ql: float):
    active_start: float | None = None
    ordered = sorted(controls, key=lambda control: float(control.get("offset_ql", 0.0)))
    for control in ordered:
        state = normalize_pedal_state(control.get("value"))
        offset = float(control.get("offset_ql", 0.0))
        if state == "down" and active_start is None:
            active_start = offset
        elif state == "up" and active_start is not None:
            attach_pedal_span(part, active_start, offset)
            active_start = None

    if active_start is not None and total_ql > active_start + 1e-6:
        attach_pedal_span(part, active_start, total_ql)


def normalize_pedal_state(value):
    state = str(value or "").strip().lower().replace("-", "_")
    if state in {"down", "start", "on", "sustain", "ped", "half", "half_pedal"}:
        return "down"
    if state in {"up", "stop", "off", "release", "clear"}:
        return "up"
    return None


def attach_pedal_span(part, start_offset: float, end_offset: float):
    if end_offset <= start_offset + 1e-6:
        return
    start = element_at_or_after(part, start_offset)
    end = element_before(part, end_offset) or element_at_or_before(part, end_offset)
    if start is None or end is None or element_offset(start, part) >= end_offset - 1e-6:
        return
    mark = expressions.PedalMark(start, end)
    mark.pedalType = expressions.PedalType.Sustain
    mark.pedalForm = expressions.PedalForm.Line
    mark.placement = "below"
    part.insert(start_offset, mark)


def attach_hairpin(part, kind: str, start_offset: float, end_offset: float):
    start = element_at_or_after(part, start_offset)
    end = element_at_or_before(part, end_offset)
    if start is None or end is None or start is end:
        # No real span to hang a wedge spanner on (e.g. only one note in range) —
        # a real dynamics mark (<dynamics><other-dynamics>, a genuine <sound
        # dynamics="..."> value), never inert text standing in for one.
        label = "cresc." if kind == "crescendo" else "dim."
        insert_at_part_offset(part, start_offset, dynamics.Dynamic(label))
        return
    cls = dynamics.Crescendo if kind == "crescendo" else dynamics.Diminuendo
    part.insert(0, cls(start, end))


def element_at_or_after(part, offset: float):
    candidates = note_candidates(part)
    for element, element_ql in candidates:
        if element_ql >= offset - 1e-6:
            return element
    return candidates[-1][0] if candidates else None


def element_at_or_before(part, offset: float):
    candidates = note_candidates(part)
    previous = None
    for element, element_ql in candidates:
        if element_ql > offset + 1e-6:
            return previous
        previous = element
    return previous


def element_before(part, offset: float):
    candidates = note_candidates(part)
    previous = None
    for element, element_ql in candidates:
        if element_ql >= offset - 1e-6:
            return previous
        previous = element
    return previous


def note_candidates(part):
    return sorted(
        ((element, element_offset(element, part)) for element in part.recurse().notesAndRests),
        key=lambda item: item[1],
    )


def element_offset(element, part):
    return float(element.getOffsetInHierarchy(part))


def _normalize_mark(mark: str) -> str:
    if isinstance(mark, str) and mark.startswith("txt:"):
        return "txt:" + mark[4:].replace("_", " ")
    return mark


def write_transport_score(transport: str | Path | dict[str, Any], out_dir: str | Path, stem: str | None = None):
    data = load_transport(transport) if not isinstance(transport, dict) else transport
    out_dir = Path(out_dir)
    stem = stem or slug(data.get("title") or "orchestral_dsl")
    score = build_score_from_transport(data)
    xml, midi = write_score_pair(score, out_dir, stem)
    sanitize_musicxml_percussion(xml)
    return {"musicxml": Path(xml), "midi": Path(midi)}


def slug(text: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9_-]+", "_", text.strip()).strip("_")
    return cleaned.lower() or "orchestral_dsl"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("transport_json")
    parser.add_argument("out_dir")
    parser.add_argument("--stem", default=None)
    args = parser.parse_args(argv)

    paths = write_transport_score(args.transport_json, args.out_dir, stem=args.stem)
    print(json.dumps({key: str(path) for key, path in paths.items()}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
