"""Shared build/export helpers."""
import re
from pathlib import Path

from . import paths


# The MusicXML <kind> "kind-value" enumeration (harmony chord kinds). music21 will
# happily emit internal chord kinds that are NOT in this set (e.g. a "G7sus4" figure
# serializes as 'suspended-fourth-seventh'), producing a .musicxml that fails schema
# validation in Dorico / Finale / Sibelius. Anything not in here must be remapped.
_VALID_MUSICXML_KINDS = frozenset({
    "major", "minor", "augmented", "diminished", "dominant",
    "major-seventh", "minor-seventh", "diminished-seventh", "augmented-seventh",
    "half-diminished", "major-minor", "major-sixth", "minor-sixth",
    "dominant-ninth", "major-ninth", "minor-ninth",
    "dominant-11th", "major-11th", "minor-11th",
    "dominant-13th", "major-13th", "minor-13th",
    "suspended-second", "suspended-fourth",
    "Neapolitan", "Italian", "French", "German", "pedal", "power", "Tristan",
    "other", "none",
})

# music21 internal kinds with no MusicXML slot -> the nearest legal value. The printed
# text="..." label on the <kind> element is preserved, so the chord symbol still READS
# the same (e.g. "7sus4"); only the schema-enum value is corrected. Unlisted unknowns
# fall back to "other" (a valid, neutral kind) so the file always validates.
_KIND_REMAP = {
    "suspended-fourth-seventh": "suspended-fourth",
    "suspended-second-seventh": "suspended-second",
    "dominant-seventh": "dominant",
    "major-pentatonic": "major",
    "minor-pentatonic": "minor",
    "pedal-point": "pedal",
}

_KIND_RE = re.compile(r"(<kind\b[^>]*>)([^<]*)(</kind>)")


def sanitize_musicxml_kinds(xml_path):
    """Rewrite, in place, any chord <kind> value the MusicXML schema rejects to a legal
    one. Returns the number of <kind> elements corrected.

    Runs after every musicxml write so an export is always schema-valid no matter what
    ChordSymbol figures a movement uses. Operates on the serialized XML (not music21
    objects) so it catches whatever the writer actually emitted. Empty <kind> bodies and
    already-valid values are left untouched; the displayed text="..." label is preserved.
    """
    p = Path(xml_path)
    try:
        text = p.read_text()
    except OSError:
        return 0
    fixed = 0

    def _fix(m):
        nonlocal fixed
        open_tag, val, close = m.group(1), m.group(2), m.group(3)
        v = val.strip()
        if not v or v in _VALID_MUSICXML_KINDS:
            return m.group(0)
        fixed += 1
        return f"{open_tag}{_KIND_REMAP.get(v, 'other')}{close}"

    new_text = _KIND_RE.sub(_fix, text)
    if fixed:
        p.write_text(new_text)
    return fixed


_LETRING_TIE_RE = re.compile(r"[ \t]*<tie type=\"let-ring\" */>\n?")


def sanitize_musicxml_ties(xml_path):
    """Remove, in place, schema-invalid <tie type="let-ring"/> elements. Returns the
    number removed.

    A laissez-vibrer tie is legal only as the VISUAL <tied type="let-ring"> inside
    <notations>; the playback <tie> element's type enum is {start, stop} and nothing
    else. music21 serializes a tie.Tie("let-ring") as both elements, so every l.v.
    export fails schema validation until the <tie> half is stripped. The <tied>
    notation (what Dorico reads) is left untouched.
    """
    p = Path(xml_path)
    try:
        text = p.read_text()
    except OSError:
        return 0
    new_text, removed = _LETRING_TIE_RE.subn("", text)
    if removed:
        p.write_text(new_text)
    return removed


_HARP_PEDALS_WORDS_RE = re.compile(r"<words[^>]*>harp-pedals:([^<]*)</words>")
_PEDAL_ALTERS = {"#": "1", "b": "-1", "": "0"}


def sanitize_musicxml_harp_pedals(xml_path):
    """Rewrite "harp-pedals:D,C,B,E,F,G,A" placeholder <words> into real <harp-pedals>
    directions, in place. Returns the number rewritten.

    music21 has no object for the MusicXML <harp-pedals> element (the seven-string
    pedal diagram), so the transport attaches the setting as a words placeholder at the
    correct offset/staff and this pass swaps the <words> element for the real diagram.
    Both elements are <direction-type> children, so the swap stays schema-valid."""
    p = Path(xml_path)
    try:
        text = p.read_text()
    except OSError:
        return 0

    def _rewrite(m):
        tunings = []
        for token in m.group(1).split(","):
            token = token.strip()
            if not token or token[0] not in "ABCDEFG":
                return m.group(0)  # malformed payload: leave the words visible, never drop it
            tunings.append(
                f"<pedal-tuning><pedal-step>{token[0]}</pedal-step>"
                f"<pedal-alter>{_PEDAL_ALTERS.get(token[1:], '0')}</pedal-alter></pedal-tuning>"
            )
        return f"<harp-pedals>{''.join(tunings)}</harp-pedals>"

    new_text, rewritten = _HARP_PEDALS_WORDS_RE.subn(_rewrite, text)
    if rewritten:
        p.write_text(new_text)
    return rewritten


def write_score_pair(score, out_dir, stem):
    """Write the score's MIDI + MusicXML (together) into out_dir. Callers organize into
    subdirs by passing an out_dir such as DSL_CARD_OUTPUTS/<category>."""
    out_dir = paths.ensure_dir(out_dir)
    xml = out_dir / f"{stem}.musicxml"
    midi = out_dir / f"{stem}.mid"
    score.write("musicxml", fp=str(xml))
    sanitize_musicxml_kinds(xml)        # schema-guard: keep the .musicxml's chord <kind>s valid
    sanitize_musicxml_ties(xml)         # schema-guard: strip invalid <tie type="let-ring"/>
    sanitize_musicxml_harp_pedals(xml)  # realize harp-pedal placeholders as <harp-pedals>
    _midi_writable(score).write("midi", fp=str(midi))
    return xml, midi


def _midi_writable(score):
    """music21's MIDI writer sees any Measure in the score and runs expandRepeats over
    EVERY part, which raises on parts that carry no measures. A score mixing pre-measured
    parts (the transport's grand-staff assembler) with flat mk_part parts is therefore
    unwritable as-is; hand the writer a fully-measured makeNotation copy instead."""
    parts = list(score.parts)
    measured = [part.hasMeasures() for part in parts]
    if any(measured) and not all(measured):
        return score.makeNotation()
    return score




def write_text(path, text):
    path = Path(path)
    paths.ensure_dir(path.parent)
    path.write_text(text)
    return path


def write_report(group, filename, text):
    return write_text(paths.report_output(group, filename), text)
