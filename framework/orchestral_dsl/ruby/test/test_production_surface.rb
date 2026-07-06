# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "sigillum/orchestral_dsl"

class ProductionSurfaceTest < Minitest::Test
  EXAMPLE = File.expand_path(
    "../../../../experiments/orchestral_dsl/production_hybrid_study.rb",
    __dir__
  )

  def test_documented_phrase_and_placement_syntax_is_executable
    piece = Sigillum::OrchestralDSL::Production.piece("Documented syntax") do
      meter "7/8", beat_pattern: [3, 2, 2]
      key "F"
      tempo "eighth = 132"

      roster do
        part :clarinet, "Clarinet", music21: "Clarinet"
      end

      section :s1, "One span", bars: 1..1, type: :proof do
        span bars: 1..1, texture: :melody do
          phrase :call, pitch: :degrees do
            key_context "F4"
            degrees "5 4"
            rhythm "1 1"
          end

          placement :call, part: :clarinet, at: "bar 1 beat 1" do
            role :foreground
            realization "C5 Bb4"
          end
        end
      end
    end

    assert_equal :degrees, piece.phrases.fetch(:call).surface
    assert_equal ["eighth = 132"], piece.tempo_marks
    assert_equal :foreground, piece.placements.first.role
    assert_equal %w[C5 Bb4], piece.timed_events.map(&:pitch)
  end

  def test_degree_surface_spells_key_relative_notes
    events = Sigillum::OrchestralDSL::Production.events_from_degrees(
      "5 4 3 #1 1",
      "1 1 1 1 1",
      "F4"
    )

    assert_equal %w[C5 Bb4 A4 F#4 F4], events.map(&:pitch)
  end

  def test_production_example_loads_all_supported_phrase_surfaces
    piece = load_piece
    compile = piece.compile_response

    assert_instance_of Sigillum::OrchestralDSL::Production::Piece, piece
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

    assert_event(events, piece, "b1:1", :clarinet, "C5", :foreground, :plain_call)
    assert_event(events, piece, "b1:1", :cello, "F2", :bass_line, :bass_path)
    assert_event(events, piece, "b3:1.5", :solo_violin, "A4", :late_answer, :late_answer_cell)
  end

  def test_vertical_and_line_readouts_are_composer_reading_views
    piece = load_piece

    verticals = Sigillum::OrchestralDSL.production_readout(piece, :verticals)
    assert_includes verticals, "b1:1"
    assert_includes verticals, "bass_line: cello=F2"
    assert_includes verticals, "foreground: clarinet=C5"
    assert_includes verticals, "late_answer: solo_violin=A4"

    line = Sigillum::OrchestralDSL.production_readout(piece, :line, part: :clarinet, bars: 1..2)
    assert_includes line, "phrase=plain_call"
    assert_includes line, "r:.5"
  end

  def test_staff_bars_are_typed_checkpoint_lanes
    piece = load_piece
    bar = piece.staff_bars.find { |candidate| candidate.number == 1 }

    assert_equal 3, bar.lanes.length
    assert_equal :foreground, bar.lanes[0].role
    assert_equal :clarinet, bar.lanes[0].part
    assert_includes bar.lanes[0].tokens, "C5"

    readout = Sigillum::OrchestralDSL.production_readout(piece, :staff_bars, bars: 1..1)
    assert_includes readout, "pulse: hand_drum: X . X X . X ."
  end

  def test_material_and_gesture_readouts_keep_relationships_visible
    piece = load_piece

    material_map = Sigillum::OrchestralDSL.production_readout(piece, :material_map)
    assert_includes material_map, "plain_call: surface=degrees"
    assert_includes material_map, "late_answer_cell -> solo_violin role=late_answer"
    assert_includes material_map, "realization: interval cell enters late against the grid"

    gesture_map = Sigillum::OrchestralDSL.production_readout(piece, :gesture_map)
    assert_includes gesture_map, "not_prose_only"
    assert_includes gesture_map, "solo_violin enters at bar 3 beat 1.5"
    refute_includes gesture_map, "mechanism: not written yet"
  end

  def test_harmony_with_melody_readout_shows_melody_against_harmony_and_bass
    piece = load_piece
    readout = Sigillum::OrchestralDSL.production_readout(piece, :harmony_with_melody, bars: 1..1)

    assert_includes readout, "# Harmony With Melody"
    assert_includes readout, "b1:1  clarinet  C5:1.5"
    assert_includes readout, 'harmony="F home; raised 1 is melodic bite, not a modulation."'
    assert_includes readout, "bass=cello=F2"
    readout_with_answer = Sigillum::OrchestralDSL.production_readout(piece, :harmony_with_melody, bars: 3..3)
    assert_includes readout_with_answer, "b3:1.5  solo_violin  A4:.5"
    assert_includes readout_with_answer, "bass=cello=F2"
  end

  def test_transport_hash_is_versioned_and_backend_ready
    piece = load_piece
    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)

    assert_equal "sigillum.orchestral_dsl.transport", transport.fetch(:schema)
    assert_equal 3, transport.fetch(:schema_version)
    assert_equal "Production Hybrid Surface Study", transport.fetch(:title)
    assert_equal "7/8", transport.fetch(:meter)
    assert_equal 28.0, transport.fetch(:total_duration_ql)
    assert_equal %w[clarinet solo_violin cello hand_drum], transport.fetch(:parts).map { |part| part.fetch(:id) }
    assert_equal %w[Clarinet Violin Violoncello Percussion], transport.fetch(:parts).map { |part| part.fetch(:music21_instrument) }
    assert_includes transport.fetch(:phrases).map { |phrase| phrase.fetch(:id) }, "plain_call"
    assert transport.fetch(:timed_events).any? { |event| event.fetch(:offset_label) == "b1:1" && event.fetch(:pitch) == "C5" }
    assert transport.fetch(:timed_events).all? { |event| event.key?(:event_type) && event.key?(:pitches) && event.key?(:pitch_label) }
    assert_equal "not_prose_only", transport.fetch(:gestures).first.fetch(:id)
  end

  def test_chords_and_inline_marks_work_across_phrase_surfaces
    absolute = Sigillum::OrchestralDSL::Production.events_from_absolute_events(
      "[A3,C4,E4]:1{mf,accent} r:.5 F#4:.5{stacc}"
    )
    assert_equal "chord", absolute.first.event_type
    assert_equal %w[A3 C4 E4], absolute.first.pitches
    assert_equal %w[mf accent], absolute.first.marks
    assert_equal "rest", absolute[1].event_type
    assert_equal %w[stacc], absolute[2].marks

    split = Sigillum::OrchestralDSL::Production.events_from_absolute(
      "[A3,C4,E4]{accent} r F#4{stacc}",
      "1 .5 .5"
    )
    assert_equal %w[A3 C4 E4], split.first.pitches
    assert_equal %w[accent], split.first.marks

    degrees = Sigillum::OrchestralDSL::Production.events_from_degrees(
      "[1,3,5]{ten} 2",
      "1 1",
      "F4"
    )
    assert_equal %w[F4 A4 C5], degrees.first.pitches
    assert_equal %w[ten], degrees.first.marks

    intervals = Sigillum::OrchestralDSL::Production.events_from_intervals(
      "[0,+3,+7]{mf} +2",
      "1 1",
      "A4"
    )
    assert_equal %w[A4 C5 E5], intervals.first.pitches
    assert_equal "B4", intervals[1].pitch
  end

  def test_controls_anchors_and_tempo_timeline_export_with_offsets
    piece = Sigillum::OrchestralDSL::Production.piece("Control surface") do
      meter "4/4"
      key "C"
      anchor :answer_entry, at: "bar 2 beat 2"

      roster do
        part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard
        part :solo_violin, "Solo Violin", music21: "Violin", family: :string
      end

      tempo do
        mark "quarter = 72", at: "bar 1 beat 1"
        ritardando from: "bar 2 beat 1", to: :answer_entry
        a_tempo at: "bar 3 beat 1"
      end

      control do
        dynamic :mf, at: "bar 1 beat 1", for: :piano_upper
        crescendo from: "bar 1 beat 1", to: :answer_entry, for: :string
        pedal :down, at: "bar 1 beat 1", for: :keyboard
      end

      section :s1, "Opening", bars: 1..3 do
        span bars: 1..3 do
          phrase :chord_call, surface: :absolute do
            events "[C4,E4,G4]:1{mf} r:1 G4:2"
          end
          placement :chord_call, part: :piano_upper, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)
    chord = transport.fetch(:timed_events).find { |event| event.fetch(:event_type) == "chord" }
    assert_equal %w[C4 E4 G4], chord.fetch(:pitches)
    assert_equal %w[mf], chord.fetch(:local_marks)
    assert_equal 1, transport.fetch(:anchors).length
    assert_equal 3, transport.fetch(:controls).length
    assert_equal 3, transport.fetch(:tempo_events).length
    assert_equal 5.0, transport.fetch(:tempo_events).find { |event| event.fetch(:kind) == "ritardando" }.fetch(:to_offset_ql)

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
    piece = Sigillum::OrchestralDSL::Production.piece("Meter changes") do
      meter "4/4"
      key "C"

      meter do
        change "3/4", at: "bar 3"
        change "5/8", at: "bar 5", beat_pattern: [3, 2]
      end

      tempo do
        mark "quarter = 72", at: "bar 1 beat 1"
        change "quarter = 96", at: "bar 3 beat 1"
      end

      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "Changing meter", bars: 1..5 do
        span bars: 1..5 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 4 beat 1", role: :foreground
        end
      end
    end

    assert_equal 11.0, Sigillum::OrchestralDSL::Production.rational_number(piece.offset_for(4, 1))
    assert_equal "b4:1", piece.format_offset(piece.offset_for(4, 1))

    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)
    assert_equal 16.5, transport.fetch(:total_duration_ql)
    assert_equal ["4/4", "3/4", "5/8"], transport.fetch(:meter_events).map { |event| event.fetch(:meter) }
    assert_equal [0.0, 8.0, 14.0], transport.fetch(:meter_events).map { |event| event.fetch(:offset_ql) }
    assert_equal [0.0, 8.0], transport.fetch(:tempo_events).map { |event| event.fetch(:offset_ql) }
    assert_equal 11.0, transport.fetch(:timed_events).find { |event| event.fetch(:phrase_id) == "call" }.fetch(:offset_ql)

    controls = Sigillum::OrchestralDSL.production_readout(piece, :controls)
    assert_includes controls, "meter 3/4 at bar 3"
    assert_includes controls, "tempo mark \"quarter = 96\" at bar 3 beat 1"
  end

  def test_meter_changes_must_land_on_bar_boundaries
    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.piece("Bad meter change") do
        meter "4/4"
        meter do
          change "3/4", at: "bar 2 beat 2"
        end
      end
    end

    assert_equal "bad_meter_change_location", error.response.fetch(:code)

    zero_error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.piece("Bad meter change") do
        meter "4/4"
        meter do
          change "3/4", at: "bar 0"
        end
      end
    end

    assert_equal "bad_meter_change_location", zero_error.response.fetch(:code)
  end

  def test_duplicate_phrase_ids_across_spans_return_structured_repair_data
    piece = Sigillum::OrchestralDSL::Production.piece("Duplicate phrase ids") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..2 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end

        span bars: 2..2 do
          phrase :call, surface: :absolute do
            events "D5:1"
          end
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "duplicate_phrase_id", response.fetch(:code)
    assert_includes response.fetch(:repair_instruction), "unique"
    assert_includes response.fetch(:docs), "docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"
  end

  def test_duplicate_phrase_ids_inside_same_span_return_structured_repair_data
    piece = Sigillum::OrchestralDSL::Production.piece("Duplicate phrase ids") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end

          phrase :call, surface: :absolute do
            events "D5:1"
          end
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "duplicate_phrase_id", response.fetch(:code)
    assert_includes response.fetch(:message), "Phrase id call"
    assert_includes response.fetch(:docs), "docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"
  end

  def test_transport_readout_returns_json
    piece = load_piece
    parsed = JSON.parse(Sigillum::OrchestralDSL.production_readout(piece, :transport))

    assert_equal "sigillum.orchestral_dsl.transport", parsed.fetch("schema")
    assert_equal "production_hybrid", parsed.fetch("source_model")
    assert_equal "C5", parsed.fetch("timed_events").find { |event| event.fetch("offset_label") == "b1:1" && event.fetch("part") == "clarinet" }.fetch("pitch")
  end

  def test_mismatched_streams_return_structured_repair_data
    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.events_from_absolute("C5 D5", "1")
    end

    response = error.response
    assert_equal "error", response.fetch(:status)
    assert_equal "surface_event_count_mismatch", response.fetch(:code)
    assert_equal :split_pitch_rhythm, response.fetch(:help_topic)
    assert_includes response.fetch(:repair_instruction), "align event-by-event"
    assert_includes response.fetch(:docs), "docs/architecture/orchestral_dsl/surfaces/split_pitch_rhythm.md"
  end

  def test_bad_absolute_pitch_reports_absolute_surface_docs
    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.events_from_absolute_events("H4:1")
    end

    response = error.response
    assert_equal "bad_pitch", response.fetch(:code)
    assert_equal :absolute, response.fetch(:help_topic)
    assert_includes response.fetch(:docs), "docs/architecture/orchestral_dsl/surfaces/absolute.md"
  end

  def test_export_refuses_compiler_error_payloads
    repo_root = File.expand_path("../../../..", __dir__)
    Dir.mktmpdir("production_export_error_", repo_root) do |dir|
      source_dir = File.join(dir, "dsl")
      FileUtils.mkdir_p(source_dir)
      source = File.join(source_dir, "bad_source.rb")
      out_dir = File.join(dir, "out")
      File.write(source, <<~RUBY)
        production_piece "Bad" do
          roster { part :clarinet, "Clarinet", music21: "Clarinet" }

          section :s1, "One", bars: 1..1 do
            span bars: 1..1 do
              phrase :call, surface: :absolute do
                events "C5:1"
              end

              phrase :call, surface: :absolute do
                events "D5:1"
              end
            end
          end
        end
      RUBY

      _stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../bin/production_export", __dir__),
        source,
        out_dir,
        "--transport-only"
      )

      refute status.success?
      assert_includes stderr, "duplicate_phrase_id"
      refute File.exist?(File.join(out_dir, "bad_source.sigillum_transport.json"))
    end
  end

  def test_compile_response_checks_control_and_tempo_anchor_references
    piece = Sigillum::OrchestralDSL::Production.piece("Missing anchor") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      tempo do
        ritardando from: "bar 1 beat 1", to: :missing_anchor
      end

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "unknown_anchor", response.fetch(:code)
  end

  def test_harp_pedals_control_normalizes_and_exports
    piece = Sigillum::OrchestralDSL::Production.piece("Harp pedals") do
      roster { part :harp, "Harp", music21: "Harp", family: :plucked }

      control do
        harp_pedals "D C B | E F G A", at: "bar 1 beat 1", for: :harp
        harp_pedals "D# C# B# | E# F# G# A#", at: "bar 2 beat 1", for: :harp
      end

      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :call, surface: :absolute do
            events "C5:4 | D5:4"
          end
          placement :call, part: :harp, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    transport = Sigillum::OrchestralDSL.production_transport_hash(piece)
    pedal_controls = transport.fetch(:controls).select { |control| control.fetch(:kind) == "harp_pedals" }
    assert_equal ["D,C,B,E,F,G,A", "D#,C#,B#,E#,F#,G#,A#"], pedal_controls.map { |control| control.fetch(:value) }
    assert_equal [0.0, 4.0], pedal_controls.map { |control| control.fetch(:offset_ql) }
  end

  def test_harp_pedals_control_rejects_out_of_order_or_partial_settings
    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.piece("Bad pedals") do
        roster { part :harp, "Harp", music21: "Harp", family: :plucked }

        control do
          harp_pedals "E F G A | D C B", at: "bar 1 beat 1", for: :harp
        end
      end
    end
    assert_equal "bad_harp_pedals", error.response.fetch(:code)

    error = assert_raises(Sigillum::OrchestralDSL::Production::CompileError) do
      Sigillum::OrchestralDSL::Production.piece("Partial pedals") do
        roster { part :harp, "Harp", music21: "Harp", family: :plucked }

        control do
          harp_pedals "D# C#", at: "bar 1 beat 1", for: :harp
        end
      end
    end
    assert_equal "bad_harp_pedals", error.response.fetch(:code)
  end

  def test_compile_response_rejects_control_targets_that_match_nothing
    piece = Sigillum::OrchestralDSL::Production.piece("Bad target") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind }

      control do
        dynamic :mf, at: "bar 1 beat 1", for: :typo_part
      end

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "unknown_control_target", response.fetch(:code)
    assert_includes response.fetch(:docs), "docs/architecture/orchestral_dsl/surfaces/controls.md"
  end

  def test_compile_response_rejects_placement_outside_containing_span
    piece = Sigillum::OrchestralDSL::Production.piece("Bad placement") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 2 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "placement_outside_span", response.fetch(:code)
  end

  def test_production_view_compile_returns_structured_errors_from_load_failures
    Dir.mktmpdir do |dir|
      source = File.join(dir, "bad_pitch.rb")
      File.write(source, <<~RUBY)
        production_piece "Bad Pitch" do
          roster { part :clarinet, "Clarinet", music21: "Clarinet" }

          section :s1, "One", bars: 1..1 do
            span bars: 1..1 do
              phrase :call, surface: :absolute do
                events "H4:1"
              end
            end
          end
        end
      RUBY

      stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../bin/production_view", __dir__),
        source,
        "compile"
      )

      assert status.success?
      assert_empty stderr
      response = JSON.parse(stdout)
      assert_equal "error", response.fetch("status")
      assert_equal "bad_pitch", response.fetch("code")
      assert_equal "absolute", response.fetch("help_topic")
    end
  end

  private

  def load_piece
    Sigillum::OrchestralDSL.load_production_file(EXAMPLE)
  end

  def assert_event(events, piece, offset, part, pitch, role, phrase)
    found = events.any? do |event|
      piece.format_offset(event.offset) == offset &&
        event.part == part &&
        event.pitch == pitch &&
        event.role == role &&
        event.phrase_id == phrase
    end
    assert found, "missing #{offset} #{part} #{pitch} role=#{role} phrase=#{phrase}"
  end
end
