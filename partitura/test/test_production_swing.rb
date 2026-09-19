# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "tmpdir"
require_relative "../lib/partitura"

class ProductionSwingTest < Minitest::Test
  def test_eighths_share_exact_onsets_and_durations_across_parts_without_mutating_source
    piece = example("C4:.5 D4:.5 r:.5 [E4,G4]:.5 C4:2")
    authored = piece.phrases.fetch(:line).events.map(&:duration)
    streams = piece.timed_events(include_rests: true).group_by(&:part).values
    expected = [[0r, 2r / 3], [2r / 3, 1r / 3], [1r, 2r / 3], [5r / 3, 1r / 3], [2r, 2r]]
    streams.each { |events| assert_equal expected, events.map { |event| [event.offset, event.duration] } }
    assert_equal [1r / 2, 1r / 2, 1r / 2, 1r / 2, 2r], authored
    assert_equal authored, piece.phrases.fetch(:line).events.map(&:duration)
    assert_equal 3, streams.size
    assert_equal :realized, piece.timing_basis
  end

  def test_sixteenths_dotted_values_and_long_syncopation_use_endpoint_mapping
    piece = example("C4:.75 D4:1.5 E4:.25 r:1.5", mode: :sixteenth)
    assert_equal [[0r, 5r / 6], [5r / 6, 3r / 2], [7r / 3, 1r / 6], [5r / 2, 3r / 2]],
                 first_part(piece).map { |event| [event.offset, event.duration] }
  end

  def test_terminal_unpaired_eighth_in_odd_meter_stays_straight
    piece = example("C4:.5 D4:.5 E4:.5", meter: "3/8")
    assert_equal [[0r, 2r / 3], [2r / 3, 1r / 3], [1r, 1r / 2]],
                 first_part(piece).map { |event| [event.offset, event.duration] }
  end

  def test_pair_grid_restarts_after_odd_meter_barline
    piece = example("C4:.5 D4:.5 E4:.5 | C4:.5 D4:.5 E4:.5", meter: "3/8", bars: 2)
    assert_equal [0r, 2r / 3, 1r, 3r / 2, 13r / 6, 5r / 2], first_part(piece).map(&:offset)
  end

  def test_mode_changes_and_off_preserve_shared_boundaries_and_total_extent
    piece = example("C4:.5 D4:.5 E4:.25 F4:.25 G4:.25 A4:.25 B4:.5 C5:.5 r:1")
    add_swing(piece, :sixteenth, "bar 1 beat 2")
    add_swing(piece, :off, "bar 1 beat 3")
    assert_equal [0r, 2r / 3, 1r, 4r / 3, 3r / 2, 11r / 6, 2r, 5r / 2, 3r], first_part(piece).map(&:offset)
    assert_equal 4r, first_part(piece).last.end_offset
  end

  def test_unaligned_or_conflicting_controls_raise_typed_errors
    piece = example("C4:4")
    add_swing(piece, :off, "bar 1 beat 1.5")
    assert_code("unaligned_swing_change") { piece.validate! }
    piece = example("C4:4")
    add_swing(piece, :sixteenth, "bar 1 beat 1")
    assert_code("conflicting_swing_controls") { piece.validate! }
    assert_code("bad_swing_mode") { example("C4:4", mode: :shuffle).validate! }
  end

  def test_active_literal_tuplets_fail_but_off_and_straight_override_preserve_them
    piece = example("C4:1/3 D4:1/3 E4:1/3 r:3")
    assert_code("nonbinary_swing_timing") { piece.validate! }
    assert_equal [1r / 3, 1r / 3, 1r / 3, 3r], first_part(piece.with_swing(:off)).map(&:duration)
    example("C4:1/3 D4:1/3 E4:1/3 r:3", mode: :off).validate!
  end

  def test_ties_crossing_bars_preserve_adjacency_and_one_sounding_attack
    piece = example("r:3.5 C4:.5{tie(} | C4:.5{tie)} D4:.5 r:3", bars: 2)
    piece.validate!
    notes = first_part(piece).reject(&:rest?)
    assert_equal [11r / 3, 4r, 14r / 3], notes.map(&:offset)
    merged = Partitura::Production.merge_authored_ties(notes)
    assert_equal [1r, 1r / 3], merged.map(&:duration)
  end

  def test_controls_tempo_and_straight_context_use_the_same_clock
    piece = example("C4:.5 D4:.5 r:3")
    piece.add_control(Partitura::Production::Control.new(kind: :dynamic, value: "ff", at: "bar 1 beat 1.5", target: :all))
    piece.add_control(Partitura::Production::Control.new(kind: :crescendo, from: "bar 1 beat 1.5", to: "bar 1 beat 2.5", target: :all))
    piece.add_tempo("quarter = 60", at: "bar 1 beat 1")
    piece.add_tempo("quarter = 120", at: "bar 1 beat 1.5")
    piece.add_anchor(:offbeat, at: "bar 1 beat 1.5")
    data = Partitura::Production.export_data(piece, exact_timing: true)
    assert_equal [2r / 3, 1r / 2], data[:anchors].last.values_at(:offset_ql, :authored_offset_ql)
    assert_equal "authored", data[:phrases].first[:timing_basis]
    assert_equal "authored", data[:placements].first[:timing_basis]
    assert_equal 2r / 3, data[:controls][1][:offset_ql]
    assert_equal [2r / 3, 5r / 3], data[:controls][2].values_at(:from_offset_ql, :to_offset_ql)
    assert_equal 2r / 3, data[:tempo_events].last[:offset_ql]
    clock = Partitura::Production::SoundingReadout::PerceptualTiming.new(piece)
    assert_in_delta 5.0 / 6, clock.seconds_at(1), 1e-12
    dynamics = Partitura::Production::SoundingReadout::PerceptualDynamics.new(piece)
    assert_equal(-9, dynamics.level(:a, 1r / 2))
    assert_equal 3, dynamics.level(:a, 2r / 3)
    straight = piece.with_swing(:off)
    assert_equal 1r / 2, straight.realized_offset_for_reference("bar 1 beat 1.5")
    assert_equal :straight_override, straight.timing_basis
    assert_equal 1r / 2, Partitura::Production.export_data(straight, exact_timing: true)[:controls][1][:offset_ql]
    assert_equal 2r / 3, piece.realized_offset_for_reference("bar 1 beat 1.5")
    assert_equal 1r / 2, piece.offset_for_reference("bar 1 beat 1.5")
  end

  def test_notation_and_import_are_expanded_once_and_do_not_request_playback_swing
    piece = example("C4:.5 D4:.5 r:3")
    xml = Partitura::Export::MusicXML.render(piece)
    doc = REXML::Document.new(xml)
    assert_empty REXML::XPath.match(doc, "//sound/swing")
    assert_equal %w[6720 3360], REXML::XPath.match(doc, "//part[1]/measure/note[pitch]/duration").map(&:text)
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, xml)
      parts, = Partitura::Production::MusicXMLImport.load_parts(path, 1, {})
      assert_equal [2r / 3, 1r / 3], parts.fetch("a").reject { |note| note.midi.nil? }.map(&:duration)
    end
  end

  def test_pickup_overwrite_is_resolved_before_shared_swing
    piece = Partitura.production_piece("Swing pickup") do
      meter "4/4"
      roster { part :a, "A", music21: "Flute", family: :woodwind }
      section :test, "Test", bars: 1..2 do
        span bars: 1..1 do
          phrase(:held, surface: :absolute) { events "C4:4" }
          placement :held, part: :a, at: "bar 1 beat 1", role: :background
        end
        span bars: 2..2 do
          phrase :pickup, surface: :absolute do
            anacrusis 0.5
            events "D4:.25 E4:.25 | F4:4"
          end
          placement :pickup, part: :a, at: "bar 2 beat 1", role: :foreground
        end
      end
      control { swing :sixteenth, at: "bar 1 beat 1" }
    end
    piece.validate!
    assert_equal [[0r, 7r / 2], [7r / 2, 1r / 3], [23r / 6, 1r / 6], [4r, 4r]],
                 first_part(piece).map { |event| [event.offset, event.duration] }
  end

  def test_authored_checkpoint_slots_follow_the_same_warp
    piece = Partitura.production_piece("Swing checkpoint") do
      meter "4/4"
      roster { part :a, "A", music21: "Flute", family: :woodwind }
      section :test, "Test", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C4:.25 D4:.25 E4:.25 F4:.25 G4:3" }
          placement :line, part: :a, at: "bar 1 beat 1", role: :foreground
          staff_bar 1 do
            foreground "a: C4 D4 E4 F4 G4 _ _ _ _ _ _ _ _ _ _ _"
          end
        end
      end
      control { swing :sixteenth, at: "bar 1 beat 1" }
    end
    assert_equal "ok", piece.compile_response[:status]
    assert_equal "ok", piece.with_swing(:off).compile_response[:status]
  end

  def test_sounding_and_source_views_distinguish_the_two_timing_contexts
    piece = example("C4:.5 D4:.5{accent} r:3")
    straight = piece.with_swing(:off)
    assert_equal Partitura.production_readout(piece, :phrases), Partitura.production_readout(straight, :phrases)
    refute_equal Partitura.production_readout(piece, :rhythm_profile), Partitura.production_readout(straight, :rhythm_profile)
    assert_includes Partitura.production_readout(piece, :timed_events), "(realized)"
    assert_includes Partitura.production_readout(straight, :timed_events), "(straight_override)"
    reader = Partitura::Production::Readout.new(piece)
    assert_equal 2r / 3, reader.send(:all_sounding).find { |event| event.pitch == "D4" }.offset
    assert_includes Partitura.production_readout(piece, :timed_events), "D4:1/3"
    grid = Partitura.production_readout(piece, :ensemble_grid)
    assert_includes grid, "1/12 ql per cell"
    assert_equal 2, grid.lines.find { |line| line.match?(/^  a\s/) }.count("X")
    assert_equal 2, grid.lines.find { |line| line.match?(/^  c\s/) }.count("X")
  end

  def test_proofpoint_musicxml_roundtrip_retains_model_onsets_pitches_and_tied_extents
    path = File.expand_path("../../experiments/partitura/proof_points/global_swing.rb", __dir__)
    piece = Partitura::Production.load_file(path)
    [piece, piece.with_swing(:off)].each do |context|
      Dir.mktmpdir do |directory|
        path = File.join(directory, "score.musicxml")
        File.write(path, Partitura::Export::MusicXML.render(context))
        # The fixture's snare uses display C5 but sounds MIDI38 (D2).
        parts, = Partitura::Production::MusicXMLImport.load_parts(path, 8, { "C5" => "D2" })
        merged = Partitura::Production.merge_authored_ties(context.timed_events)
        context.parts.values.each do |part|
          expected = merged.select { |event| event.part == part.id }.flat_map do |event|
            event.pitches.map do |pitch|
              number = part.id == :snare ? 38 : Partitura::Production.pitch_to_midi(pitch)
              [event.offset, event.duration, number]
            end
          end
          name = Partitura::Production::MusicXMLImport.norm_part(part.name)
          imported = Partitura::Production::MusicXMLImport.merge_ties(parts.fetch(name), beats: 4)
          actual = imported.reject { |note| note.midi.nil? }.map do |note|
            [context.offset_for(note.bar, 1) + note.onset, note.duration, note.midi]
          end
          assert_equal expected.sort, actual.sort, "#{part.id} #{context.timing_basis}"
        end
      end
    end
  end

  private

  def first_part(piece)
    piece.timed_events(include_rests: true).select { |event| event.part == :a }
  end

  def add_swing(piece, value, at)
    piece.add_control(Partitura::Production::Control.new(kind: :swing, value: value.to_s, at: at, target: :all))
  end

  def assert_code(code)
    error = assert_raises(Partitura::Production::CompileError) { yield }
    assert_equal code, error.response[:code]
  end

  def example(events, mode: :eighth, meter: "4/4", bars: 1)
    Partitura.production_piece("Global swing fixture") do
      meter meter
      key "C"
      roster do
        part :a, "A", music21: "Flute", family: :woodwind
        part :b, "B", music21: "Viola", family: :string
        part :c, "C", music21: "Percussion", family: :percussion
      end
      section :test, "Test", bars: 1..bars do
        span bars: 1..bars do
          phrase(:line, surface: :absolute) { events events }
          placement :line, part: :a, at: "bar 1 beat 1", role: :foreground
          placement :line, part: :b, at: "bar 1 beat 1", role: :inner
          placement :line, part: :c, at: "bar 1 beat 1", role: :rhythm
        end
      end
      control { swing mode, at: "bar 1 beat 1" }
    end
  end
end
