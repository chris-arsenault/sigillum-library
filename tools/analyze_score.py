"""Analyse a score into per-melody-note musical features and print the readout.

    python -m tools.analyze_score path/to/song.mid
    python -m tools.analyze_score --chorale bach/bwv66.6
    python -m tools.analyze_score --m1            # the locked M1 theme (known motif structure)

See ``docs/architecture/feature_extraction.md``.
"""
import argparse
from collections import Counter

from framework.analysis import analyze_events, analyze_midi, analyze_score
from framework.analysis.events import NoteEvent
from framework.analysis.tonal import NOTE_NAMES


def _readout(notes, name, limit=24):
    fig = Counter(n.features["figuration"]["figure"] for n in notes)
    tf = Counter(n.features["motif"]["transform"] for n in notes if n.features["motif"]["transform"] != "-")
    print(f"\n### {name}   ({len(notes)} melody notes)")
    print("  figuration:", dict(fig.most_common(6)))
    print("  motif restatements:", sum(tf.values()), dict(tf.most_common(5)))
    print("  per-note (onset | pitch | degree | roman role | figure | motif):")
    for n in notes[:limit]:
        h, t, f, m = n.features["harmony"], n.features["tonal"], n.features["figuration"], n.features["motif"]
        deg = t["degree"] if not t["chromatic"] else "chr"
        print(f"    b{n.onset:6.2f}  {NOTE_NAMES[n.midi % 12]:<2}  ^{str(deg):<3} "
              f"{h['roman'] + h['inversion']:<8} {h['role']:<12} {f['figure']:<11} {m['transform']}")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("midi", nargs="?", help="a MIDI file to analyse")
    parser.add_argument("--chorale", help="a music21 bundled-corpus path, e.g. bach/bwv66.6")
    parser.add_argument("--m1", action="store_true", help="analyse the locked RENN_FULL theme")
    args = parser.parse_args(argv)

    if args.m1:
        from music21 import pitch as m21pitch
        from symphony.materials.themes import RENN_FULL
        events, t = [], 0.0
        for item in RENN_FULL:
            if item[0] is not None:
                events.append(NoteEvent(t, int(m21pitch.Pitch(item[0]).midi), float(item[1])))
            t += float(item[1])
        _readout(analyze_events(events, t), "RENN_FULL")
    elif args.chorale:
        from music21 import corpus
        _readout(analyze_score(corpus.parse(args.chorale)), args.chorale)
    elif args.midi:
        _readout(analyze_midi(args.midi), args.midi)
    else:
        parser.error("give a MIDI path, --chorale <name>, or --m1")


if __name__ == "__main__":
    main()
