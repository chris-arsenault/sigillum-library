"""Composition AIDS — everything a human editor needs, emitted INTO the movement
output directory (outputs/movements/). The editor reads ONLY that directory: never
docstrings, never code. So a movement's score gets chord symbols ON the staff, a
readable markdown notes file lands beside it, and key themes / carry-forward material
are exported as separate reference MIDIs.

  add_chord_symbols(score, chords)      -> chord symbols on the score (MusicXML), no MIDI pollution
  write_movement_notes(stem, text)      -> outputs/movements/<stem>_notes.md
  export_reference_midis(stem, refs)    -> outputs/movements/<stem>_ref_<name>.mid per item
"""
from music21 import harmony, expressions

from . import paths
from .score import mk_part, mk_score


MUSICXML_TEXT_ONLY_CHORD_KINDS = {
    # music21 exports this as <kind>suspended-fourth-seventh</kind>, but
    # MusicXML's schema allows suspended-fourth and dominant separately, not this value.
    "suspended-fourth-seventh",
}


def _chord_text(figure):
    te = expressions.TextExpression(figure)
    te.style.fontStyle = "normal"
    return te


def _normalize_root_flat(figure):
    """harmony.ChordSymbol only recognizes '-' for a flat root ('B-', not 'Bb') and
    raises on the plain-English spelling everyone actually types. Rewrite a lowercase
    'b' immediately after the root letter (the accidental position) to '-'; leaves
    quality letters alone ('Bbm' -> 'B-m', but 'Dm' is untouched since there's no
    accidental there)."""
    if len(figure) > 1 and figure[0] in "ABCDEFG" and figure[1] == "b":
        return figure[0] + "-" + figure[2:]
    return figure


def chord_symbol_or_text(figure):
    """Convert one figure like 'Bbmaj9', 'Gm9', 'F9', 'D', 'Bbm' to a real
    harmony.ChordSymbol (notation only: writeAsChord=False -> shows above the staff,
    adds no MIDI notes), or a plain text marking if the figure can't be parsed as a
    chord or hits a MusicXML kind the schema can't express, so nothing silently
    drops."""
    try:
        cs = harmony.ChordSymbol(_normalize_root_flat(figure))
        if getattr(cs, "chordKind", None) in MUSICXML_TEXT_ONLY_CHORD_KINDS:
            return _chord_text(figure)
        cs.writeAsChord = False
        return cs
    except Exception:
        return _chord_text(figure)


def add_chord_symbols(score, chords, part_index=0):
    """Insert chord symbols at absolute quarter-length offsets into one staff.
    `chords` = [(offset_ql, figure), ...]."""
    part = score.parts[part_index]
    for offset, figure in chords:
        part.insert(offset, chord_symbol_or_text(figure))
    return score


def write_movement_notes(stem, text, out_dir=None):
    """Write the human-readable composition notes beside the score."""
    out = paths.ensure_dir(out_dir or paths.MOVEMENT_OUTPUTS)
    fp = out / f"{stem}_notes.md"
    fp.write_text(text)
    return fp


def cards_used_block(sections):
    """Markdown provenance block: which library cards each section actually pulled and how.
    `sections` = [(label, module), ...]; a module may export
    CARDS_USED = [(card_name, how_used), ...]. Lands in the movement notes the editor reads."""
    out = ["## Library cards used (provenance — what each section pulled from the library and how)"]
    found = False
    for label, mod in sections:
        cu = getattr(mod, "CARDS_USED", None)
        if not cu:
            continue
        found = True
        out.append(f"\n**{label}**")
        out += [f"- `{name}` — {how}" for name, how in cu]
    if not found:
        out.append("\n_(no section declared cards yet)_")
    return "\n".join(out) + "\n"


def audit_block(section_parts, roster):
    """Run the dynamics+tempo audit over a movement's concatenated section parts and format it
    for the notes. `section_parts` = list of {instrument: notelist}; `roster` = [(name, cls), …]."""
    from . import audit
    parts = [(name, sum((list(sp[name]) for sp in section_parts), [])) for name, _ in roster]
    return audit.format_audit(audit.audit(parts))


def export_reference_midis(stem, refs, out_dir=None):
    """Export key material as standalone reference MIDIs in the output dir.
    `refs` = {name: (notelist, instrument_class, tempo)} — one `<stem>_ref_<name>.mid` each."""
    out = paths.ensure_dir(out_dir or paths.MOVEMENT_OUTPUTS)
    written = []
    for name, (notelist, instr, tempo) in refs.items():
        sc = mk_score(f"{stem} — {name}", "4/4", "C",
                      [mk_part(name, instr(), list(notelist))], tempo_events=[(0, tempo)])
        fp = out / f"{stem}_ref_{name}.mid"
        sc.write("midi", fp=str(fp))
        written.append(fp)
    return written
