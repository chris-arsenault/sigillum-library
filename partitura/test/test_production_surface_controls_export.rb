# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceControlsExportTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_chords_and_inline_marks_work_across_phrase_surfaces
    assert_absolute_chord_marks
    assert_split_chord_marks
    assert_degree_chord_marks
    assert_interval_chord_marks
  end

  def test_controls_anchors_and_tempo_timeline_export_with_offsets
    piece = control_surface_piece

    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)
    chord = transport.fetch(:timed_events).find { |event| event.fetch(:event_type) == "chord" }
    assert_equal %w[C4 E4 G4], chord.fetch(:pitches)
    assert_equal %w[mf], chord.fetch(:local_marks)
    assert_equal 1, transport.fetch(:anchors).length
    assert_equal 3, transport.fetch(:controls).length
    assert_equal 3, transport.fetch(:tempo_events).length
    assert_equal 5.0, transport.fetch(:tempo_events).find { |event|
 event.fetch(:kind) == "ritardando" }.fetch(:to_offset_ql)

    controls = Sigillum::OrchestralDSL.production_readout(piece, :controls)
    assert_includes controls, "anchor answer_entry=bar 2 beat 2"
    assert_includes controls, "crescendo from bar 1 beat 1 to answer_entry for string"

    timed_events = Sigillum::OrchestralDSL.production_readout(piece, :timed_events)
    assert_includes timed_events, "[C4,E4,G4]:1"
    assert_includes timed_events, "marks={mf}"
  end

  def test_roster_exports_notation_group_metadata
    piece = Sigillum::OrchestralDSL::Production.piece("Notation metadata") do
      meter "4/4"
      key "C"

      roster do
        part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard,
          notation_group: :piano, notation_staff: 1
        part :piano_middle, "Piano Middle", music21: "Piano", family: :keyboard,
          notation_group: :piano, notation_staff: :auto
        part :piano_lower, "Piano Lower", music21: "Piano", family: :keyboard,
          notation_group: :piano, notation_staff: 2
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:upper, surface: :absolute) { events "C5:4" }
          placement :upper, part: :piano_upper, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    parts = Sigillum::OrchestralDSL.production_transport_hash(piece).fetch(:parts)
    assert_equal "piano", parts[0].fetch(:notation_group)
    assert_equal "Piano", parts[0].fetch(:music21_instrument)
    assert_equal "1", parts[0].fetch(:notation_staff)
    assert_equal "auto", parts[1].fetch(:notation_staff)
    assert_equal "2", parts[2].fetch(:notation_staff)
  end

  def test_roster_parts_require_explicit_music21_instrument
    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.piece("Missing backend instrument") do
        roster { part :oboe, "Oboe" }
      end
    end

    assert_equal "missing_music21_instrument", error.response.fetch(:code)
    assert_includes error.response.fetch(:repair_instruction), "music21"
  end

  def test_meter_and_tempo_changes_affect_offsets_and_transport
    piece = meter_changes_piece

    assert_equal 11.0, Sigillum::OrchestralDSL::Production.rational_number(piece.offset_for(4, 1))
    assert_equal "b4:1", piece.format_offset(piece.offset_for(4, 1))

    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)
    assert_equal 16.5, transport.fetch(:total_duration_ql)
    assert_equal(["4/4", "3/4", "5/8"], transport.fetch(:meter_events).map { |event| event.fetch(:meter) })
    assert_equal([0.0, 8.0, 14.0], transport.fetch(:meter_events).map { |event| event.fetch(:offset_ql) })
    assert_equal([0.0, 8.0], transport.fetch(:tempo_events).map { |event| event.fetch(:offset_ql) })
    assert_equal 11.0, transport.fetch(:timed_events).find { |event|
 event.fetch(:phrase_id) == "call" }.fetch(:offset_ql)

    controls = Sigillum::OrchestralDSL.production_readout(piece, :controls)
    assert_includes controls, "meter 3/4 at bar 3"
    assert_includes controls, "tempo mark \"quarter = 96\" at bar 3 beat 1"
  end

  private

  def assert_absolute_chord_marks
    events = Sigillum::OrchestralDSL::Production.events_from_absolute_events(
      "[A3,C4,E4]:1{mf,accent} r:.5 F#4:.5{stacc}"
    )
    assert_equal "chord", events.first.event_type
    assert_equal %w[A3 C4 E4], events.first.pitches
    assert_equal %w[mf accent], events.first.marks
    assert_equal "rest", events[1].event_type
    assert_equal %w[stacc], events[2].marks
  end

  def assert_split_chord_marks
    events = Sigillum::OrchestralDSL::Production.events_from_absolute("[A3,C4,E4]{accent} r F#4{stacc}", "1 .5 .5")
    assert_equal %w[A3 C4 E4], events.first.pitches
    assert_equal %w[accent], events.first.marks
  end

  def assert_degree_chord_marks
    events = Sigillum::OrchestralDSL::Production.events_from_degrees("[1,3,5]{ten} 2", "1 1", "F4")
    assert_equal %w[F4 A4 C5], events.first.pitches
    assert_equal %w[ten], events.first.marks
  end

  def assert_interval_chord_marks
    events = Sigillum::OrchestralDSL::Production.events_from_intervals("[0,+3,+7]{mf} +2", "1 1", "A4")
    assert_equal %w[A4 C5 E5], events.first.pitches
    assert_equal "B4", events[1].pitch
  end

  def control_surface_piece
    Sigillum::OrchestralDSL::Production.piece("Control surface") do
      meter "4/4"; key "C"; anchor :answer_entry, at: "bar 2 beat 2"
      roster {
 part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard;
 part :solo_violin, "Solo Violin", music21: "Violin", family: :string }
      tempo {
 mark "quarter = 72", at: "bar 1 beat 1";
 ritardando from: "bar 2 beat 1", to: :answer_entry; a_tempo at: "bar 3 beat 1" }
      control {
 dynamic :mf, at: "bar 1 beat 1", for: :piano_upper;
 crescendo from: "bar 1 beat 1", to: :answer_entry, for: :string; pedal :down, at: "bar 1 beat 1", for: :keyboard }
      section :s1, "Opening", bars: 1..3 do
        span bars: 1..3 do
          phrase(:chord_call, surface: :absolute) { events "[C4,E4,G4]:1{mf} r:1 G4:2" }
          placement :chord_call, part: :piano_upper, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def meter_changes_piece
    Sigillum::OrchestralDSL::Production.piece("Meter changes") do
      meter "4/4"; key "C"
      meter { change "3/4", at: "bar 3"; change "5/8", at: "bar 5", beat_pattern: [3, 2] }
      tempo { mark "quarter = 72", at: "bar 1 beat 1"; change "quarter = 96", at: "bar 3 beat 1" }
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }
      section :s1, "Changing meter", bars: 1..5 do
        span bars: 1..5 do
          phrase(:call, surface: :absolute) { events "C5:1" }
          placement :call, part: :clarinet, at: "bar 4 beat 1", role: :foreground
        end
      end
    end
  end
end
