"""Core builders for the Sigillum symphony project.
Note item format: (pitch_or_chordlist_or_None, quarterLength, *tokens) where tokens are markings:
  dynamics: ppp pp p mp mf f ff fff sfz fp  — these set MIDI velocity; use them for AUDIBLE dynamics.
  artic: stacc accent ten marc spicc. harm detache  |  "trem" (3-slash roll)
  percussion: "rimshot" (circle-x head + accent), "xstick" (x head), "choke" (+ stopped),
    "stick:R"/"stick:L" (sticking as lyric text)
  ring: "lv" (laissez vibrer) = a real MusicXML <tied type="let-ring">; when the note already
    carries a structural tie (one music21 tie slot), it renders as the standard "l.v." text
    at that point instead — matching Dorico's own l.v.-on-a-tie export.
  rolled chords: "arp" (default up-roll <arpeggiate/>), "arp:up", "arp:down", "arp:non"
    (bracketed non-arpeggio) — real MusicXML <arpeggiate> on every chord member, not text.
  glissando: "gliss(" ... "gliss)" as a START/END pair = a real <glissando line-type="wavy">
    spanner labeled "gliss." between the two notes; pairs may chain on one note
    ({gliss),gliss(}) and may cross barlines.
  slurs: "slur(" ... "slur)"  (usually via legato()).
  trills: bare "trill" for a single note, or "trill(" ... "trill)" spanning several —
    a real trill-mark + wavy-line, not text.
  hairpins (notation): "cresc(" ... "cresc)" / "dim(" ... "dim)" as a START/END pair = a real wedge.
    Bare "<" ">" "<>" render as a TEXT marking (cresc./dim./cresc-dim); they do NOT pair into a wedge.
  bowing state: "pizz" / "arco" are distinct tokens (not text you have to word-match), a real
    bowing STATE that holds until the matching cancel token — every note in between gets the
    semantic music21 Pizzicato articulation (MusicXML <note pizzicato="yes">), plus the usual
    visible "pizz."/"arco" label.
  technique text: "txt:<technique>" (e.g. "txt:con sord."). ANY other unrecognized string
    token also renders as an italic text marking — markings are never silently dropped.
Every renderer (single-staff mk_part and the transport's grand-staff assembler) applies this
one vocabulary through apply_event_marks — there is exactly one set of technique tokens.
Articulations attach to MATERIAL definitions, so musical revisions inherit them."""
from music21 import (stream, note, chord, tempo, meter, key, metadata, dynamics,
                     articulations as m21artic, expressions as m21expr,
                     spanner as m21spanner, tie as m21tie)

DYNS = {"ppp", "pp", "p", "mp", "mf", "f", "ff", "fff", "sfz", "fp"}
ARTICS = {"stacc": m21artic.Staccato, "accent": m21artic.Accent,
          "ten": m21artic.Tenuto, "marc": m21artic.StrongAccent,
          "spicc.": m21artic.Spiccato, "harm": m21artic.Harmonic,
          "detache": m21artic.DetachedLegato}
ARPEGGIOS = {"arp": "normal", "arp:up": "up", "arp:down": "down", "arp:non": "non-arpeggio"}


def new_mark_state():
    """Spanner/bowing state threaded through apply_event_marks across one voice's events."""
    return {"slur_start": None, "trill_start": None, "wedge": None,
            "gliss_start": None, "pizz": False}


def _italic_text(label):
    te = m21expr.TextExpression(label)
    te.style.fontStyle = "italic"
    return te


def apply_event_marks(el, tokens, state, insert_point, insert_spanner):
    """Apply mark tokens (module docstring vocabulary) to one event.

    el            : the music21 Note/Chord/Rest the tokens belong to.
    state         : dict from new_mark_state(), shared across the voice's events.
    insert_point  : callback placing a point object (Dynamic, TextExpression) at the
                    event's own position in the score.
    insert_spanner: callback adding a spanner (Slur, Glissando, wedge, TrillExtension)
                    to the containing part/staff.

    Call this for EVERY event, even with no tokens: an active pizz state still stamps
    the Pizzicato articulation on sounding notes.
    """
    for tok in tokens:
        if tok in DYNS:
            insert_point(dynamics.Dynamic(tok))
        elif tok in ARTICS:
            el.articulations.append(ARTICS[tok]())
        elif tok in ARPEGGIOS:
            el.expressions.append(m21expr.ArpeggioMark(ARPEGGIOS[tok]))
        elif tok == "trem":
            el.expressions.append(m21expr.Tremolo(numberOfMarks=3))
        elif tok == "rimshot":
            # no dedicated MusicXML element exists; the circle-x notehead is the
            # standard engraving and noteheads survive Dorico import
            el.notehead = "circle-x"
            el.articulations.append(m21artic.Accent())
        elif tok == "xstick":
            el.notehead = "x"
        elif tok == "choke":
            # MusicXML <technical><stopped/> = the "+" symbol: mute/choke/closed
            el.articulations.append(m21artic.Stopped())
        elif tok == "lv":
            if el.tie is None:
                # laissez vibrer: MusicXML <tied type="let-ring">
                el.tie = m21tie.Tie("let-ring")
            else:
                # the single music21 tie slot is taken by a structural tie; the
                # standard engraving (and Dorico's own export) is "l.v." text here
                insert_point(_italic_text("l.v."))
        elif isinstance(tok, str) and tok.startswith("stick:"):
            # sticking has no MusicXML element; lyric text R/L is the portable form
            el.addLyric(tok[6:])
        elif tok == "trill":
            el.expressions.append(m21expr.Trill())
            insert_spanner(m21expr.TrillExtension(el))
        elif tok == "trill(":
            el.expressions.append(m21expr.Trill())
            state["trill_start"] = el
        elif tok == "trill)":
            if state["trill_start"] is not None:
                insert_spanner(m21expr.TrillExtension(state["trill_start"], el))
            state["trill_start"] = None
        elif tok == "slur(":
            state["slur_start"] = el
        elif tok == "slur)":
            if state["slur_start"] is not None and state["slur_start"] is not el:
                insert_spanner(m21spanner.Slur(state["slur_start"], el))
            state["slur_start"] = None
        elif tok == "gliss(":
            state["gliss_start"] = el
        elif tok == "gliss)":
            if state["gliss_start"] is not None and state["gliss_start"] is not el:
                gliss = m21spanner.Glissando(state["gliss_start"], el)
                gliss.label = "gliss."
                insert_spanner(gliss)
            state["gliss_start"] = None
        elif tok in ("cresc(", "dim("):
            state["wedge"] = (tok[:-1], el)
        elif tok in ("cresc)", "dim)"):
            wedge = state["wedge"]
            if wedge is not None and wedge[1] is not el:
                cls = dynamics.Crescendo if wedge[0] == "cresc" else dynamics.Diminuendo
                insert_spanner(cls(wedge[1], el))
            state["wedge"] = None
        elif tok == "pizz":
            state["pizz"] = True
            insert_point(_italic_text("pizz."))
        elif tok == "arco":
            state["pizz"] = False
            insert_point(_italic_text("arco"))
        elif isinstance(tok, str) and tok.startswith("txt:"):
            insert_point(_italic_text(tok[4:]))
        elif tok in ("<", ">", "<>"):
            # A bare, unpaired hairpin symbol (no matching "cresc)"/"dim)" to make a
            # real wedge from) still needs to actually affect the sound, not just
            # decorate the page — dynamics.Dynamic with a non-standard string exports
            # as a real <dynamics><other-dynamics> element with a genuine <sound
            # dynamics="..."> value, unlike inert TextExpression. For a real notated
            # wedge use the "cresc(".."cresc)" / "dim(".."dim)" pair instead.
            label = {"<": "cresc.", ">": "dim.", "<>": "cresc-dim"}[tok]
            insert_point(dynamics.Dynamic(label))
        elif isinstance(tok, str):
            # Never silently drop a marking. Technique words ("con sord.", ...) with
            # no dedicated notation element render as an italic text marking
            # instead of vanishing.
            insert_point(_italic_text(tok))
    if state["pizz"] and not isinstance(el, note.Rest):
        el.articulations.append(m21artic.Pizzicato())


def R(ql):
    return (None, ql)


def rest_bars(n, beats=4):
    return [R(beats) for _ in range(n)]


def mk_part(name, instr, items, validate_ql=None):
    p = stream.Part()
    p.partName = name
    p.insert(0, instr)
    total = 0.0
    state = new_mark_state()
    insert_spanner = lambda sp: p.insert(0, sp)  # noqa: E731
    for it in items:
        pitches, ql = it[0], it[1]
        if pitches is None:
            el = note.Rest(quarterLength=ql)
        elif isinstance(pitches, list):
            el = chord.Chord(pitches, quarterLength=ql)
        else:
            el = note.Note(pitches, quarterLength=ql)
        apply_event_marks(el, it[2:], state, p.append, insert_spanner)
        p.append(el)
        total += ql
    if validate_ql is not None:
        assert abs(total - validate_ql) < 1e-6, \
            f"Part '{name}': {total} ql, expected {validate_ql}"
    return p


def mk_score(title, ts, ksig, parts, tempo_events, meter_events=None):
    """Build a Score from finished parts.

    ts          : the movement time signature (e.g. "4/4"), used when meter_events is None.
    meter_events: OPTIONAL list of (offset_ql, ts_str) for movements that CHANGE meter
                  mid-piece (e.g. a 3/4 passacaglia pivoting to a 4/4 march and back).
                  Each TimeSignature is inserted at its ql offset in EVERY part so music21
                  bars the change correctly; offsets MUST land on bar boundaries. The first
                  event should be at offset 0.0. When given, `ts` is ignored.
    """
    s = stream.Score()
    s.metadata = metadata.Metadata(title=title, composer="Sigillum project")
    first = True
    for p in parts:
        # pitches are entered at CONCERT pitch; mark so MusicXML export writes proper
        # transposed parts (clarinet/horn/trumpet/contrabass) instead of attaching a
        # <transpose> tag to concert values (which made Dorico sound winds -M2/-P5)
        p.atSoundingPitch = True
        if meter_events:
            for off, t in meter_events:
                p.insert(off, meter.TimeSignature(t))
        else:
            p.insert(0, meter.TimeSignature(ts))
        p.insert(0, key.Key(ksig))
        if first:
            for off, bpm in tempo_events:
                p.insert(off, tempo.MetronomeMark(number=bpm))
            first = False
        s.insert(0, p)
    return s


def legato(items, span_ql=16.0):
    """Slur contiguous sounding runs, split at span boundaries (phrase length) and rests."""
    out = [list(it) for it in items]
    groups, cur, cur_span = [], [], None
    t = 0.0
    for i, it in enumerate(out):
        sp = int(t // span_ql + 1e-9)
        if it[0] is None:
            if cur:
                groups.append(cur)
            cur, cur_span = [], None
        else:
            if cur_span is None:
                cur_span = sp
            elif sp != cur_span:
                groups.append(cur)
                cur, cur_span = [], sp
            cur.append(i)
        t += it[1]
    if cur:
        groups.append(cur)
    for g in groups:
        if len(g) >= 2:
            out[g[0]].append("slur(")
            out[g[-1]].append("slur)")
    return [tuple(it) for it in out]


def tag(items, *tokens):
    """Attach tokens (e.g. 'txt:pizz.') to the first sounding item. Returns a copy."""
    out = [list(it) for it in items]
    for it in out:
        if it[0] is not None:
            it.extend(tokens)
            break
    return [tuple(it) for it in out]


def marc(items, tok="accent"):
    return [tuple(list(it) + [tok]) if it[0] is not None else it for it in items]


def ten(items):
    return marc(items, tok="ten")


def arp_bar(up, dur=0.25):
    return [(p, dur) for p in up] + [(p, dur) for p in reversed(up)]


def arp_bar_8ths(up):
    return [(p, 0.5) for p in up]


def _wedge(items, kind):
    out = [list(it) for it in items]
    first = last = None
    for i, it in enumerate(out):
        if it[0] is not None:
            if first is None:
                first = i
            last = i
    if first is not None and last is not None and last != first:
        out[first].append(kind + "(")
        out[last].append(kind + ")")
    return [tuple(it) for it in out]


def cresc(items):
    return _wedge(items, "cresc")


def dim(items):
    return _wedge(items, "dim")
