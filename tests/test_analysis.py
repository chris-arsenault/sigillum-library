import unittest

from framework.analysis import Knobs, NoteEvent, analyze_events, analyze_full
from framework.analysis.basic import _strength
from framework.analysis.figuration import figuration, sequences
from framework.analysis.harmony import accompaniment, chord_vocab, note_role, windowed_harmony
from framework.analysis.motif import detect
from framework.analysis.tonal import (
    diatonic_ordinals, estimate_key, pc_histogram, scale_degree,
)

KNOBS = Knobs()


def scale_events(roots, dur=1.0):
    out, t = [], 0.0
    for m in roots:
        out.append(NoteEvent(t, m, dur))
        t += dur
    return out, t


class TonalTests(unittest.TestCase):
    def test_key_estimation_c_major(self):
        events, _ = scale_events([60, 62, 64, 65, 67, 69, 71, 72])
        self.assertEqual(estimate_key(pc_histogram(events)), (0, "major"))

    def test_scale_degree_and_chromatic(self):
        self.assertEqual(scale_degree(60, 0, "major"), 1)   # C is degree 1 of C major
        self.assertEqual(scale_degree(67, 0, "major"), 5)   # G is degree 5
        self.assertIsNone(scale_degree(61, 0, "major"))     # C# is chromatic

    def test_diatonic_ordinals_step_by_one(self):
        ordinals = diatonic_ordinals(0, "major")
        self.assertEqual(ordinals[62] - ordinals[60], 1)    # C -> D is one scale step
        self.assertNotIn(61, ordinals)                      # C# omitted


class HarmonyTests(unittest.TestCase):
    def test_chord_position_labels(self):
        pcs, root = frozenset({0, 4, 7}), 0          # C major triad
        self.assertEqual(note_role(None, 60, 64, pcs, root), "ct:R")
        self.assertEqual(note_role(60, 64, 67, pcs, root), "ct:3")
        self.assertEqual(note_role(64, 67, 72, pcs, root), "ct:5")

    def test_passing_tone_classified(self):
        pcs, root = frozenset({0, 4, 7}), 0
        self.assertEqual(note_role(60, 62, 64, pcs, root), "nct:passing")   # C-D-E, D passes
        self.assertEqual(note_role(60, 62, 60, pcs, root), "nct:neighbor")  # C-D-C, D neighbours

    def test_windowed_harmony_finds_tonic(self):
        # a sustained C major triad in the accompaniment -> window labelled I
        texture = [NoteEvent(0.0, 48, 2.0), NoteEvent(0.0, 52, 2.0), NoteEvent(0.0, 55, 2.0)]
        windows = windowed_harmony(texture, 2.0, (0, "major"), KNOBS)
        self.assertTrue(windows and windows[0][1] == "I")

    def test_accompaniment_excludes_melody(self):
        mel = [NoteEvent(0.0, 72, 1.0)]
        texture = [NoteEvent(0.0, 72, 1.0), NoteEvent(0.0, 48, 1.0)]
        self.assertEqual(accompaniment(texture, mel), [NoteEvent(0.0, 48, 1.0)])

    def test_vocab_is_key_relative(self):
        c = dict((label, root) for label, _pcs, root in chord_vocab(0, "major"))
        g = dict((label, root) for label, _pcs, root in chord_vocab(7, "major"))
        self.assertEqual(c["V"], 7)              # V of C is rooted on G
        self.assertEqual(g["V"], 2)              # V of G is rooted on D


class FigurationTests(unittest.TestCase):
    def test_ascending_scale_is_a_run(self):
        P = [60, 62, 64, 65, 67]
        labels = figuration(P, [1.0] * 5, [False] * 5, KNOBS)
        self.assertTrue(all(l == "run-up" for l in labels))

    def test_repeated_note(self):
        labels = figuration([60, 60, 60], [1.0] * 3, [False] * 3, KNOBS)
        self.assertTrue(all(l == "repeat" for l in labels))

    def test_fast_alternation_is_trill_slow_is_neighbor(self):
        fast = figuration([72, 74, 72, 74, 72], [0.25] * 5, [False] * 5, KNOBS)
        slow = figuration([72, 74, 72, 74, 72], [2.0] * 5, [False] * 5, KNOBS)
        self.assertIn("trill", fast)
        self.assertNotIn("trill", slow)

    def test_sequence_flag(self):
        # interval cell [+2,+2] repeated
        self.assertTrue(any(sequences([60, 62, 64, 66, 68, 70])))


class MotifTests(unittest.TestCase):
    def test_exact_repeat_detected(self):
        cell = [60, 62, 64, 65, 67]
        P = cell + cell
        labels = detect(P, [1.0] * 10, diatonic_ordinals(0, "major"), KNOBS)
        self.assertTrue(all(l == "exact" for l in labels[5:10]))
        self.assertTrue(all(l == "-" for l in labels[:5]))   # the first statement is the reference

    def test_tonal_transpose_detected(self):
        cell = [60, 62, 64, 65, 67]            # C D E F G
        up_a_step = [62, 64, 65, 67, 69]       # D E F G A — same scale steps, different semitones
        labels = detect(cell + up_a_step, [1.0] * 10, diatonic_ordinals(0, "major"), KNOBS)
        self.assertTrue(all(l == "tonal-transpose" for l in labels[5:10]))


class SegmentTests(unittest.TestCase):
    def test_rising_contour(self):
        events, total = scale_events(list(range(60, 76)))   # ascending over 4 bars
        _notes, seg = analyze_full(events, total)
        self.assertEqual(seg.archetype, "rising")
        self.assertGreater(seg.apex_position, 0.7)

    def test_arch_contour(self):
        events, total = scale_events(list(range(60, 72)) + list(range(72, 60, -1)))
        _notes, seg = analyze_full(events, total)
        self.assertEqual(seg.archetype, "arch")

    def test_style_fingerprint_has_expected_signals(self):
        events, total = scale_events([60, 62, 64, 65, 67, 69, 71, 72])
        _notes, seg = analyze_full(events, total)
        for key in ("figuration_profile", "chromatic_rate", "note_density",
                    "mean_interval", "harmonic_color"):
            self.assertIn(key, seg.style)

    def test_angularity_distinguishes_styles(self):
        stepwise, total = scale_events([60, 62, 64, 65, 67, 69, 71, 72])
        leapy, _ = scale_events([60, 67, 60, 69, 60, 71, 60, 72])
        _, s_step = analyze_full(stepwise, total)
        _, s_leap = analyze_full(leapy, total)
        self.assertLess(s_step.style["mean_interval"], s_leap.style["mean_interval"])


class PipelineTests(unittest.TestCase):
    def test_analyze_assembles_all_tiers(self):
        texture, total = scale_events([60, 62, 64, 65, 67, 69, 71, 72])
        notes = analyze_events(texture, total)
        self.assertEqual(len(notes), 8)
        for name in ("tonal", "harmony", "figuration", "motif", "metric"):
            self.assertIn(name, notes[0].features)
        self.assertEqual(notes[0].features["metric"]["strength"], "downbeat")

    def test_strength_buckets(self):
        self.assertEqual(_strength(0.0, 4.0), "downbeat")
        self.assertEqual(_strength(2.0, 4.0), "halfbar")
        self.assertEqual(_strength(1.0, 4.0), "beat")
        self.assertEqual(_strength(1.5, 4.0), "offbeat")


if __name__ == "__main__":
    unittest.main()
