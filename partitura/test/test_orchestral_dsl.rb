# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura/orchestral_dsl"

class OrchestralDSLTest < Minitest::Test
  EXAMPLE = File.expand_path(
    "../../experiments/orchestral_dsl/storyteller_surface_study.rb",
    __dir__
  )

  def test_note_parser_handles_rests_chords_durations_and_marks
    notes = Sigillum::OrchestralDSL::NoteParser.parse("C5:1.5 r:.5 [F3,C4]:.25{mp,lv}")

    assert_equal "C5", notes[0].pitch
    assert_equal Rational(3, 2), notes[0].duration
    assert notes[1].rest?
    assert_equal ["F3", "C4"], notes[2].pitch
    assert_equal Rational(1, 4), notes[2].duration
    assert_equal %w[mp lv], notes[2].marks
  end

  def test_piece_surface_loads_substantial_example
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)

    assert_equal "Storyteller Surface Study", piece.title
    assert_equal 7, piece.parts.length
    assert_equal 4, piece.sections.length
    assert_equal 16, piece.bars_range.end
    assert piece.materials.key?(:plain_call)
    assert piece.materials.key?(:missed_answer)
  end

  def test_phrase_labels_persist_until_changed
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)
    foreground = Sigillum::OrchestralDSL.projection(piece, :foreground, bars: 1..2)

    assert_includes foreground, 'phrase="plain call"'
    assert_includes foreground, 'phrase="answering tail"'
  end

  def test_material_map_keeps_transform_as_provenance_with_materialized_notes
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)
    map = Sigillum::OrchestralDSL.projection(piece, :material_map)

    assert_includes map, "plain_call | moved into violin register and diverted at the cadence"
    assert_includes map, "materialized: C5:1 Bb4:.5 A4:.5"
    assert_includes map, "missed_answer"
  end

  def test_gesture_map_keeps_poetry_attached_to_musical_mechanism
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)
    gestures = Sigillum::OrchestralDSL.projection(piece, :gesture_map)

    assert_includes gestures, "not_a_fade"
    assert_includes gestures, "short fragments, separated rests, and staggered final exits"
    assert_includes gestures, "silence follows active departures"
  end

  def test_vertical_projection_shows_cross_voice_moment
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)
    verticals = Sigillum::OrchestralDSL.projection(piece, :verticals, bars: 9..10)

    assert_includes verticals, "b9:1"
    assert_includes verticals, "foreground: clarinet=C5"
    assert_includes verticals, "late_answer: solo_violin=A4"
    assert_includes verticals, "pulse_engine: hand_drum=C3"
  end

  def test_line_projection_keeps_rests_and_roles_visible
    piece = Sigillum::OrchestralDSL.load_file(EXAMPLE)
    line = Sigillum::OrchestralDSL.projection(piece, :line, part: :hand_drum, bars: 13..16)

    assert_includes line, "role pulse_stops"
    assert_includes line, "r:3.5"
  end
end
