"""Note events and melody extraction — the shared front of the feature pipeline.

A score (MIDI or music21) becomes a flat list of pitched ``NoteEvent``s in beats (drums dropped),
each tagged with the voice (track/channel or part) it came from. The melody is the most
melody-like voice's top line — see ``melody_line``. Every feature extractor works from these.
"""
from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass

_DRUM_CHANNEL = 9


@dataclass(frozen=True)
class NoteEvent:
    onset: float      # beats from the start
    midi: int
    duration: float   # beats
    voice: int = 0    # source voice id (track*16+channel for MIDI, part index for music21)
    velocity: int = 64  # MIDI note-on velocity (1-127); 64 = mf default when a source has none


DEFAULT_BARLEN = 4.0   # beats per bar when the file carries no time signature (assume 4/4)


def events_from_midi(path: str) -> tuple[list[NoteEvent], float, float]:
    """All pitched note events (drums on channel 9 dropped), sorted by onset, + total beats +
    bar length in beats read from the file's first time signature (DEFAULT_BARLEN if none).

    Each note keeps its ``voice`` = track*16 + channel, so the melody extractor can tell the
    lead apart from the bass / arp / pad voices a multi-track rip separates them into.
    """
    import mido

    mid = mido.MidiFile(path)
    tpb = mid.ticks_per_beat or 480
    events: list[NoteEvent] = []
    timesig: tuple[int, float] | None = None     # (absolute tick, barlen-in-beats) of the earliest
    for track_index, track in enumerate(mid.tracks):
        t = 0
        sounding: dict[tuple[int, int], tuple[int, int]] = {}   # (channel,note) -> (start_tick, velocity)
        for msg in track:
            t += msg.time
            if msg.type == "time_signature" and (timesig is None or t < timesig[0]):
                timesig = (t, msg.numerator * 4.0 / msg.denominator)
            elif msg.type == "note_on" and msg.velocity > 0 and msg.channel != _DRUM_CHANNEL:
                sounding[(msg.channel, msg.note)] = (t, msg.velocity)
            elif (msg.type == "note_off" or (msg.type == "note_on" and msg.velocity == 0)) \
                    and (msg.channel, msg.note) in sounding:
                start, vel = sounding.pop((msg.channel, msg.note))
                events.append(NoteEvent(start / tpb, msg.note, max((t - start) / tpb, 1 / 12),
                                        track_index * 16 + msg.channel, vel))
    events.sort(key=lambda e: (e.onset, e.midi))
    total = max((e.onset + e.duration for e in events), default=0.0)
    barlen = timesig[1] if timesig and timesig[1] > 0 else DEFAULT_BARLEN
    return events, total, barlen


def events_from_music21(score) -> tuple[list[NoteEvent], float, float]:
    """Flatten a music21 score into NoteEvents (offsets = beats); ``voice`` = part index. Bar length
    in beats comes from the first time signature (DEFAULT_BARLEN if none)."""
    parts = list(getattr(score, "parts", []) or [])
    sources = list(enumerate(parts)) if parts else [(0, score)]
    events: list[NoteEvent] = []
    for pi, part in sources:
        for n in part.flatten().notes:
            vel = int(getattr(n.volume, "velocity", None) or 64)
            pitches = n.pitches if n.isChord else [n.pitch]
            for p in pitches:
                events.append(NoteEvent(float(n.offset), int(p.midi), float(n.quarterLength) or 0.25, pi, vel))
    events.sort(key=lambda e: (e.onset, e.midi))
    total = max((e.onset + e.duration for e in events), default=0.0)
    ts = list(score.flatten().getElementsByClass("TimeSignature"))
    barlen = float(ts[0].barDuration.quarterLength) if ts else DEFAULT_BARLEN
    return events, total, barlen


# Melody-likeness scoring, ported from the corpus voice-scorer (generation.theme_gen.corpus):
# the melody is the most melody-like VOICE, not the global top note. A lead sits in a higher
# (non-bass) register, uses varied pitch classes, and is near-monophonic (low polyphony); a chord
# pad or interleaved melody+bass line is rejected. All swappable.
_MIN_MELODY_NOTES = 6
_MIN_MELODY_PCS = 3
_MAX_BIG_LEAP_FRACTION = 0.15   # a line leaping > an octave this often is melody+bass interleaved
_BIG_LEAP = 12
_REGISTER_W = 1.0
_VARIETY_W = 3.0
_POLYPHONY_W = 8.0              # gentle tiebreaker: a harmonized lead is still the melody
# The melody CARRIES the piece; an intro sting / ornamental cue / high descant does not. The raw
# corpus heuristic lacks this, so a sparse high voice can out-score the lead on register alone.
# Require a candidate voice to span at least this fraction of the timeline (first onset to last
# release, so internal rests don't disqualify a real melody). Swappable.
_MIN_COVERAGE = 0.5


def _topline(events: list[NoteEvent]) -> list[NoteEvent]:
    """The monophonic top line of a note set: the highest-pitched note starting at each distinct
    onset (top of any chord), as real NoteEvents. Keeps every onset — a fast legato line is NOT
    thinned, unlike a cursor-skipping skyline — so a busy melody isn't mistaken for a sparse one."""
    best: dict[float, NoteEvent] = {}
    for e in events:
        k = round(e.onset, 4)
        if k not in best or e.midi > best[k].midi:
            best[k] = e
    return [best[k] for k in sorted(best)]


def _polyphony(events: list[NoteEvent]) -> float:
    """Fraction of a voice's sounding time during which more than one of its notes overlaps — the
    real chord/pad signature (a sweep, not a dropped-note count, so legato melody reads as ~0)."""
    edges: list[tuple[float, int]] = []
    for e in events:
        edges.append((round(e.onset, 4), 1))
        edges.append((round(e.onset + e.duration, 4), -1))
    edges.sort()
    active = 0
    last: float | None = None
    total = poly = 0.0
    for t, delta in edges:
        if last is not None and t > last:
            total += t - last
            if active > 1:
                poly += t - last
        active += delta
        last = t
    return poly / total if total else 0.0


def _melody_score(line: list[NoteEvent], polyphony: float) -> float | None:
    """Melody-likeness of a monophonic line (register + pitch-class variety - polyphony), or None
    if it fails the gates (too few notes, too little variety, or too leapy to be singable)."""
    midis = [e.midi for e in line]
    if len(midis) < _MIN_MELODY_NOTES:
        return None
    pcs = len({m % 12 for m in midis})
    if pcs < _MIN_MELODY_PCS:
        return None
    leaps = [abs(midis[i + 1] - midis[i]) for i in range(len(midis) - 1)]
    if leaps and sum(1 for v in leaps if v > _BIG_LEAP) / len(leaps) > _MAX_BIG_LEAP_FRACTION:
        return None
    return _REGISTER_W * (sum(midis) / len(midis)) + _VARIETY_W * pcs - _POLYPHONY_W * polyphony


def melody_line(events: list[NoteEvent]) -> list[NoteEvent]:
    """The melodic line of a texture: the most melody-like voice's top line, as real NoteEvents.

    Multi-part rips separate lead / bass / arpeggio / pad into distinct voices, and the melody is
    rarely the global top note (it dips under a high pad, or a countermelody crosses it). We split
    the texture by voice, take each voice's monophonic top line, score it for melody-likeness
    (register + pitch-class variety - polyphony), and return the winner. When no voice qualifies
    (e.g. a single interleaved voice, or a very short file) we fall back to the global top line.

    Returned notes are members of ``events`` (not reconstructed), so the harmony tier can subtract
    the melody from the texture by onset+pitch.
    """
    if not events:
        return []
    total = max(e.onset + e.duration for e in events)
    by_voice: dict[int, list[NoteEvent]] = defaultdict(list)
    for e in events:
        by_voice[e.voice].append(e)

    best: list[NoteEvent] | None = None
    best_score: float | None = None
    for notes in by_voice.values():
        span = max(e.onset + e.duration for e in notes) - min(e.onset for e in notes)
        if total > 0 and span / total < _MIN_COVERAGE:
            continue                       # a cue / sting / ornament, not the carrying melody
        line = _topline(notes)
        score = _melody_score(line, _polyphony(notes))
        if score is not None and (best_score is None or score > best_score):
            best, best_score = line, score

    return best if best is not None else _topline(events)
