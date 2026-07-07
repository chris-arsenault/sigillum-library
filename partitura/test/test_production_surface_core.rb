# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceCoreTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_documented_phrase_and_placement_syntax_is_executable
    piece = documented_syntax_piece

    assert_equal :degrees, piece.phrases.fetch(:call).surface
    assert_equal ["eighth = 132"], piece.tempo_marks
    assert_equal :foreground, piece.placements.first.role
    assert_equal %w[C5 Bb4], piece.timed_events.map(&:pitch)
  end

  def test_degree_surface_spells_key_relative_notes
    events = Partitura::Production.events_from_degrees(
      "5 4 3 #1 1",
      "1 1 1 1 1",
      "F4"
    )

    assert_equal %w[C5 Bb4 A4 F#4 F4], events.map(&:pitch)
  end

  def test_production_example_loads_all_supported_phrase_surfaces
    piece = load_piece
    compile = piece.compile_response

    assert_instance_of Partitura::Production::Piece, piece
    assert_equal "ok", compile.fetch(:status)
    assert_includes compile.fetch(:surface_summary), "degrees"
    assert_includes compile.fetch(:surface_summary), "intervals"
    assert_includes compile.fetch(:surface_summary), "split_pitch_rhythm"
    assert_includes compile.fetch(:surface_summary), "absolute"
    assert_includes compile.fetch(:available_projections), "peak_axes"
    assert_includes compile.fetch(:available_projections), "recurrence_map"
    assert_includes compile.fetch(:available_projections), "controls"
    assert_includes compile.fetch(:secondary_declared_intent_projections), "gesture_map"
    assert_includes compile.fetch(:secondary_declared_intent_projections), "harmony_with_melody"
    assert_includes compile.fetch(:available_exports), "transport_json"
    assert_includes compile.fetch(:available_exports), "musicxml"
  end

  def test_placements_materialize_as_timed_events
    piece = load_piece
    events = piece.timed_events

    assert_event(events, piece, offset: "b1:1", part: :clarinet, pitch: "C5", role: :foreground, phrase: :plain_call)
    assert_event(events, piece, offset: "b1:1", part: :cello, pitch: "F2", role: :bass_line, phrase: :bass_path)
    assert_event(
      events,
      piece,
      offset: "b3:1.5",
      part: :solo_violin,
      pitch: "A4",
      role: :late_answer,
      phrase: :late_answer_cell
    )
  end

  def test_vertical_and_line_readouts_are_composer_reading_views
    piece = load_piece

    verticals = Partitura.production_readout(piece, :verticals)
    assert_includes verticals, "b1:1"
    assert_includes verticals, "bass_line: cello=F2"
    assert_includes verticals, "foreground: clarinet=C5"
    assert_includes verticals, "late_answer: solo_violin=A4"

    line = Partitura.production_readout(piece, :line, part: :clarinet, bars: 1..2)
    assert_includes line, "phrase=plain_call"
    assert_includes line, "r:.5"

    probe = Partitura.production_readout(piece, :bar_probe, bars: 1..1)
    assert_includes probe, "--- Production Hybrid Surface Study bar 1 ---"
    assert_includes probe, "clarinet       [0-1.5]C5"
    assert_includes piece.compile_response.fetch(:available_projections), "bar_probe"
  end

  def test_sounding_audit_projections_cover_clashes_grid_and_stalls
    piece = audit_projection_piece

    grid = Partitura.production_readout(piece, :ensemble_grid, bars: 1..1)
    assert_includes grid, "# Ensemble Grid"
    assert_includes grid, "upper"
    assert_includes grid, "lower"

    clashes = Partitura.production_readout(piece, :exposed_clashes, bars: 1..1)
    assert_includes clashes, "lower:C4-upper:D4"
    assert_includes clashes, "iv2"
    assert_includes clashes, "upper leaves by step@2"

    stalls = Partitura.production_readout(piece, :composite_stalls)
    assert_includes stalls, "# Composite Stalls"
    assert_includes stalls, "b1@2 gap 4"
    assert_includes stalls, "held: lower"
  end

  def test_staff_bars_are_typed_checkpoint_lanes
    piece = load_piece
    bar = piece.staff_bars.find { |candidate| candidate.number == 1 }

    assert_equal 3, bar.lanes.length
    assert_equal :foreground, bar.lanes[0].role
    assert_equal :clarinet, bar.lanes[0].part
    assert_includes bar.lanes[0].tokens, "C5"

    readout = Partitura.production_readout(piece, :staff_bars, bars: 1..1)
    assert_includes readout, "pulse: hand_drum: X . X X . X ."
  end

  def test_material_and_gesture_readouts_keep_relationships_visible
    piece = load_piece

    material_map = Partitura.production_readout(piece, :material_map)
    assert_includes material_map, "plain_call: surface=degrees"
    assert_includes material_map, "late_answer_cell -> solo_violin at bar 3 beat 1.5 role=late_answer"
    assert_includes material_map, "realization: interval cell enters late against the grid"

    gesture_map = Partitura.production_readout(piece, :gesture_map)
    assert_includes gesture_map, "not_prose_only"
    assert_includes gesture_map, "solo_violin enters at bar 3 beat 1.5"
    refute_includes gesture_map, "mechanism: not written yet"
  end

  def test_harmony_with_melody_readout_shows_melody_against_harmony_and_bass
    piece = load_piece
    readout = Partitura.production_readout(piece, :harmony_with_melody, bars: 1..1)

    assert_includes readout, "# Harmony With Melody"
    assert_includes readout, "b1:1  clarinet  C5:1.5"
    assert_includes readout, 'harmony="F home; raised 1 is melodic bite, not a modulation."'
    assert_includes readout, "bass=cello=F2"
    readout_with_answer = Partitura.production_readout(piece, :harmony_with_melody, bars: 3..3)
    assert_includes readout_with_answer, "b3:1.5  solo_violin  A4:.5"
    assert_includes readout_with_answer, "bass=cello=F2"
  end

  private

  def documented_syntax_piece
    Partitura::Production.piece("Documented syntax") do
      meter "7/8", beat_pattern: [3, 2, 2]
      key "F"
      tempo "eighth = 132"
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }
      section :s1, "One span", bars: 1..1, type: :proof do
        span bars: 1..1, texture: :melody do
          phrase(:call, pitch: :degrees) { key_context "F4"; degrees "5 4"; rhythm "1 1" }
          placement :call, part: :clarinet, at: "bar 1 beat 1" do
            role :foreground
            realization "C5 Bb4"
          end
        end
      end
    end
  end

  def audit_projection_piece
    Partitura::Production.piece("Audit projections") do
      meter "4/4"
      key "C"
      roster { part :upper, "Upper", music21: "Flute"; part :lower, "Lower", music21: "Cello" }
      section :s1, "Audit span", bars: 1..2 do
        span bars: 1..2 do
          phrase(:upper_line, surface: :absolute) { events "D4:1 E4:1 r:3 F4:1" }
          phrase(:lower_line, surface: :absolute) { events "C4:1 G3:4 r:1" }
          placement :upper_line, part: :upper, at: "bar 1 beat 1", role: :foreground
          placement :lower_line, part: :lower, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end
end
