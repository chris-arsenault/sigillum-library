# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class MIDIExporterTest < Minitest::Test
  def test_renders_standard_midi_file
    midi = Partitura.production_midi(simple_piece)

    assert_equal "MThd", midi.byteslice(0, 4)
    assert_equal 6, midi.byteslice(4, 4).unpack1("N")
    assert_equal 1, midi.byteslice(8, 2).unpack1("n")
    assert_equal 2, midi.byteslice(10, 2).unpack1("n")
    assert_equal 10_080, midi.byteslice(12, 2).unpack1("n")
    assert_includes midi, "MTrk"
    assert_includes midi.bytes, 0x90
    assert_includes midi.bytes, 0x80
  end

  def test_export_renderer_accepts_piece_only
    midi = Partitura::Export::MIDI.render(simple_piece)

    assert_equal "MThd", midi.byteslice(0, 4)
    assert_equal simple_piece.parts.length + 1, midi.byteslice(10, 2).unpack1("n")
  end

  def test_text_controls_preserve_the_empty_notes_metadata_track
    midi = Partitura::Export::MIDI.render(text_control_piece)

    assert_equal 3, midi.byteslice(10, 2).unpack1("n")
    assert_includes midi, "Notes"
  end

  def test_emits_tuba_and_timpani_program_changes
    tuba_midi = Partitura::Export::MIDI.render(instrument_piece("Tuba", :brass, "C2:4"))
    timpani_midi = Partitura::Export::MIDI.render(instrument_piece("Timpani", :pitched_percussion, "D2:4"))

    assert_includes tuba_midi, [0xC0, 58].pack("C*")
    assert_includes timpani_midi, [0xC0, 47].pack("C*")
  end

  def test_dotted_quarter_tempo_normalizes_to_quarter_bpm
    midi = Partitura.production_midi(tempo_piece("dotted-quarter = 52"))

    assert_in_delta 769_231, first_tempo_microseconds(midi), 1
  end

  def test_quarter_tempo_preserves_its_written_bpm
    midi = Partitura.production_midi(tempo_piece("quarter = 120"))

    assert_equal 500_000, first_tempo_microseconds(midi)
  end

  def test_emits_meter_and_key_change_timelines
    midi = Partitura.production_midi(meter_and_key_change_piece)

    assert_equal [
      [0, [4, 2, 24, 8]],
      [8 * 10_080, [3, 2, 24, 8]]
    ], tempo_track_meta_events(midi, 0x58)
    assert_equal [
      [0, [0, 0]],
      [4 * 10_080, [-2, 1]],
      [11 * 10_080, [2, 0]]
    ], tempo_track_meta_events(midi, 0x59, unpack: "cC")
  end

  def test_midi_export_rejects_unrepresentable_raw_tempo_events
    piece = tempo_piece("quarter = 120")
    piece.add_tempo_event(
      Partitura::Production::TempoEvent.new(kind: :mark, text: "raw", at: "bar 1 beat 1", bpm: 2)
    )

    error = assert_raises(Partitura::Export::Error) { Partitura.production_midi(piece) }
    assert_includes error.message, "outside the MIDI playback range"
  end

  def test_thirds_and_sixths_land_on_exact_midi_ticks
    piece = instrument_piece("Flute", :woodwind, "C4:1/3 D4:1/6 E4:1/3 F4:1/6 G4:3")
    notes = note_events(Partitura.production_midi(piece))

    assert_equal [0, 3360, 5040, 8400, 10_080], notes.select { |event| event[1] == 0x90 }.map(&:first)
    assert_equal [3360, 5040, 8400, 10_080, 40_320], notes.select { |event| event[1] == 0x80 }.map(&:first)
  end

  def test_local_and_scoped_dynamics_apply_at_exact_fractional_onsets
    midi = Partitura.production_midi(fractional_dynamic_piece)

    [1, 2].each do |track|
      attacks = note_events(midi, track: track).select { |event| (event[1] & 0xF0) == 0x90 }
      assert_equal [3_062_640, 3_064_320], attacks.map(&:first)
      assert_equal [88, 88], attacks.map(&:last), "fractional f must apply at its attack and persist"
    end
  end

  def test_fractional_ties_merge_without_retrigger_and_keep_following_dynamics
    piece = instrument_piece("Flute", :woodwind,
                             "r:1/3 C4:1/6{p,tie(} C4:1/3{f,tie)} r:1/6 D4:3")

    assert_equal [
      [3360, 0x90, 60, 48],
      [8400, 0x80, 60, 0],
      [10_080, 0x90, 62, 88],
      [40_320, 0x80, 62, 0]
    ], note_events(Partitura.production_midi(piece))
  end

  def test_unrepresentable_fraction_rounds_to_nearest_tick
    piece = instrument_piece("Flute", :woodwind, "C4:2/11 D4:42/11")
    notes = note_events(Partitura.production_midi(piece))

    assert_equal [0, 1833], notes.select { |event| event[1] == 0x90 }.map(&:first)
    assert_equal [1833, 40_320], notes.select { |event| event[1] == 0x80 }.map(&:first)
  end

  def test_ghost_attenuates_only_its_event_and_preserves_timing_and_following_dynamic
    piece = instrument_piece("Flute", :woodwind, "C4:1{mf} D4:1{ghost} E4:1 F4:1{ghost}")
    attacks = note_events(Partitura.production_midi(piece)).select { |event| event[1] == 0x90 }

    assert_equal [0, 10_080, 20_160, 30_240], attacks.map(&:first)
    assert_equal [60, 62, 64, 65], attacks.map { |event| event[2] }
    assert_equal [72, 18, 72, 18], attacks.map(&:last)
  end

  def test_accents_and_marcato_boost_only_their_attacks
    piece = instrument_piece("Flute", :woodwind, "C4:1{mf} D4:1{accent} E4:1{marc} F4:1")
    attacks = note_events(Partitura.production_midi(piece)).select { |event| event[1] == 0x90 }

    assert_equal [0, 10_080, 20_160, 30_240], attacks.map(&:first)
    assert_equal [72, 114, 127, 72], attacks.map(&:last)
  end

  def test_attack_adjustments_compose_before_clipping_regardless_of_mark_order
    piece = instrument_piece("Flute", :woodwind,
                             "C4:.5{fff,accent,ghost} D4:.5{ghost,accent} " \
                             "E4:.5{marc,ghost} F4:.5{ghost,marc} " \
                             "G4:.5{accent,marc,ghost} A4:.5{marc,accent,ghost} " \
                             "B4:.5{accent,marc} C5:.5")
    attacks = note_events(Partitura.production_midi(piece)).select { |event| event[1] == 0x90 }

    assert_equal [46, 46, 58, 58, 92, 92, 127, 116], attacks.map(&:last)
  end

  def test_percussion_accents_and_ghosts_preserve_the_prevailing_dynamic
    piece = instrument_piece("Percussion", :percussion,
                             "F#2:1{p} F#2:1{accent} F#2:1{ghost,marc} F#2:1")
    attacks = note_events(Partitura.production_midi(piece)).select { |event| event[1] == 0x99 }

    assert_equal [42, 42, 42, 42], attacks.map { |event| event[2] }
    assert_equal [48, 76, 24, 48], attacks.map(&:last)
  end

  def test_attack_adjustments_follow_scoped_hairpins_without_changing_the_ramp
    piece = Partitura::Production.piece("Articulated Crescendo") do
      meter "4/4"
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      control do
        dynamic :p, at: "bar 1 beat 1", for: :flute
        crescendo from: "bar 1 beat 1", to: "bar 1 beat 3", for: :flute
        dynamic :mf, at: "bar 1 beat 3", for: :flute
      end
      section :s, "Phrase", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C4:1{accent} D4:1 E4:1{marc} F4:1" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
    attacks = note_events(Partitura.production_midi(piece)).select { |event| event[1] == 0x90 }

    assert_equal [76, 58, 127, 72], attacks.map(&:last)
  end

  def test_staccato_gates_chords_and_combines_with_attack_marks_without_moving_next_onset
    piece = instrument_piece("Flute", :woodwind,
                             "[C4,E4]:1{mf,stacc,accent,ghost} D4:1{ten} E4:1{stacc,marc} F4:1")

    assert_equal [
      [0, 0x90, 60, 29], [0, 0x90, 64, 29],
      [5040, 0x80, 60, 0], [5040, 0x80, 64, 0],
      [10_080, 0x90, 62, 72], [20_160, 0x80, 62, 0],
      [20_160, 0x90, 64, 127], [25_200, 0x80, 64, 0],
      [30_240, 0x90, 65, 72], [40_320, 0x80, 65, 0]
    ], note_events(Partitura.production_midi(piece))
  end

  def test_authored_ties_sustain_despite_staccato_and_do_not_retrigger_or_inherit_accent
    piece = instrument_piece("Flute", :woodwind,
                             "C4:.5{p,stacc,accent,tie(} C4:.5{marc,tie)} D4:3{ten}")

    assert_equal [
      [0, 0x90, 60, 76], [10_080, 0x80, 60, 0],
      [10_080, 0x90, 62, 48], [40_320, 0x80, 62, 0]
    ], note_events(Partitura.production_midi(piece))
  end

  def test_staccato_uses_exact_fractional_duration_and_retains_long_untied_note_gate
    piece = instrument_piece("Flute", :woodwind,
                             "C4:1/3{stacc} D4:1/6{stacc} E4:5/2{stacc} F4:1{ten}")
    notes = note_events(Partitura.production_midi(piece))

    assert_equal [0, 3360, 5040, 30_240], notes.select { |event| event[1] == 0x90 }.map(&:first)
    assert_equal [1680, 4200, 17_640, 40_320], notes.select { |event| event[1] == 0x80 }.map(&:first)
  end

  def test_staccato_preserves_a_positive_tick_for_a_tiny_note
    piece = instrument_piece("Flute", :woodwind,
                             "C4:1/100000{stacc} r:99999/100000 D4:3")
    notes = note_events(Partitura.production_midi(piece))

    assert_equal [0, 10_080], notes.select { |event| event[1] == 0x90 }.map(&:first)
    assert_equal [1, 40_320], notes.select { |event| event[1] == 0x80 }.map(&:first)
  end

  def test_global_swing_maps_note_gates_dynamics_and_tempo_together
    piece = instrument_piece("Flute", :woodwind, "C4:.25 D4:.25{stacc} E4:.5 r:3")
    piece.add_control(Partitura::Production::Control.new(kind: :swing, value: "sixteenth", at: "bar 1 beat 1", target: :all))
    piece.add_control(Partitura::Production::Control.new(kind: :dynamic, value: "f", at: "bar 1 beat 1.25", target: :all))
    piece.add_tempo("quarter = 60", at: "bar 1 beat 1")
    piece.add_tempo("quarter = 120", at: "bar 1 beat 1.25")
    midi = Partitura.production_midi(piece)
    ons = note_events(midi).select { |event| event[1] == 0x90 }
    offs = note_events(midi).select { |event| event[1] == 0x80 }
    assert_equal [0, 3360, 5040], ons.map(&:first)
    assert_equal [3360, 4200, 10080], offs.map(&:first)
    assert_equal [72, 88, 88], ons.map(&:last)
    assert_equal [0, 3360], tempo_track_meta_events(midi, 0x51).map(&:first)
    straight = Partitura.production_midi(piece.with_swing(:off))
    assert_equal [0, 2520, 5040], note_events(straight).select { |event| event[1] == 0x90 }.map(&:first)
    assert_equal [0, 2520], tempo_track_meta_events(straight, 0x51).map(&:first)
  end

  def test_global_swing_proofpoint_midi_preserves_every_realized_note_in_both_contexts
    path = File.expand_path("../../experiments/partitura/proof_points/global_swing.rb", __dir__)
    piece = Partitura::Production.load_file(path)
    [piece, piece.with_swing(:off)].each do |context|
      midi = Partitura.production_midi(context)
      merged = Partitura::Production.merge_authored_ties(context.timed_events)
      context.parts.values.each_with_index do |part, index|
        expected = merged.select { |event| event.part == part.id }.flat_map do |event|
          event.pitches.map do |pitch|
            number = if part.percussion_map.key?(pitch)
                       Partitura::PercussionDevices::DEVICES.fetch(part.percussion_map.fetch(pitch)).fetch(:midi_note)
                     else
                       Partitura::Production.pitch_to_midi(pitch)
                     end
            [(event.offset * 10_080).to_i, (event.end_offset * 10_080).to_i, number]
          end
        end
        actual = note_events(midi, track: index + 1)
        ons = actual.select { |event| (event[1] & 0xF0) == 0x90 }.map { |tick, _, pitch, _velocity| [tick, pitch] }
        offs = actual.select { |event| (event[1] & 0xF0) == 0x80 }.map { |tick, _, pitch, _velocity| [tick, pitch] }
        assert_equal expected.map { |start, _, pitch| [start, pitch] }.sort, ons.sort
        assert_equal expected.map { |_, finish, pitch| [finish, pitch] }.sort, offs.sort
      end
    end
  end

  private

  def simple_piece
    tempo_piece("quarter = 120")
  end

  def tempo_piece(tempo_mark)
    Partitura::Production.piece("MIDI Export Core") do
      meter "4/4"
      key "C"
      tempo tempo_mark

      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:1{mf} E5:1 G5:2" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def instrument_piece(instrument, family, event_text)
    Partitura::Production.piece("#{instrument} Program") do
      meter "4/4"
      key "C"

      roster do
        part :instrument, instrument, music21: instrument, family: family
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events event_text }
          placement :line, part: :instrument, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def fractional_dynamic_piece
    Partitura::Production.piece("Fractional Dynamic Boundary") do
      meter "4/4"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :violin, "Violin", music21: "Violin", family: :string
      end
      control do
        dynamic :pp, at: "bar 76 beat 1", for: :all
        dynamic :f, at: "bar 76 beat 29/6", for: :violin
      end
      section :s, "Late fractional entry", bars: 76..77 do
        span bars: 76..77 do
          phrase(:wind, surface: :absolute) { events "r:23/6 C5:1/6{f} | D5:4" }
          phrase(:string, surface: :absolute) { events "r:23/6 G4:1/6 | A4:4" }
          placement :wind, part: :flute, at: "bar 76 beat 1", role: :foreground
          placement :string, part: :violin, at: "bar 76 beat 1", role: :answer
        end
      end
    end
  end

  def note_events(midi, track: 1)
    position = 14
    track.times { position += 8 + midi.byteslice(position + 4, 4).unpack1("N") }
    track_end = position + 8 + midi.byteslice(position + 4, 4).unpack1("N")
    position += 8
    tick = 0
    notes = []
    while position < track_end
      delta, position = read_variable_length(midi, position)
      tick += delta
      status = midi.getbyte(position)
      position += 1
      if status == 0xFF
        length, position = read_variable_length(midi, position + 1)
        position += length
      else
        length = [0xC0, 0xD0].include?(status & 0xF0) ? 1 : 2
        data = midi.byteslice(position, length).bytes
        notes << [tick, status, *data] if [0x80, 0x90].include?(status & 0xF0)
        position += length
      end
    end
    notes
  end

  def meter_and_key_change_piece
    Partitura::Production.piece("MIDI Meter And Key Timeline") do
      meter "4/4"
      key "C"
      meter { change "3/4", at: "bar 3" }
      control { key_change "g", at: "bar 2"; key_change "D", at: "bar 4" }

      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s1, "Changing Grid", bars: 1..4 do
        span bars: 1..4 do
          phrase(:line, surface: :absolute) { events "C5:1" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def text_control_piece
    Partitura::Production.piece("MIDI Text Control") do
      meter "4/4"
      key "C"
      control { text "mark this transition", at: "bar 1 beat 1", for: :all }
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def first_tempo_microseconds(midi)
    position = 14
    raise "invalid MIDI tempo track" unless midi.byteslice(position, 4) == "MTrk"

    track_length = midi.byteslice(position + 4, 4).unpack1("N")
    position += 8
    track_end = position + track_length
    while position < track_end
      _delta, position = read_variable_length(midi, position)
      raise "expected MIDI meta event" unless midi.getbyte(position) == 0xFF

      type = midi.getbyte(position + 1)
      data_length, data_position = read_variable_length(midi, position + 2)
      if type == 0x51
        raise "invalid MIDI tempo event" unless data_length == 3

        return midi.byteslice(data_position, 3).bytes.reduce(0) { |value, byte| (value << 8) | byte }
      end
      position = data_position + data_length
    end

    raise "MIDI tempo event not found"
  end

  def tempo_track_meta_events(midi, wanted_type, unpack: nil)
    position = 14
    raise "invalid MIDI tempo track" unless midi.byteslice(position, 4) == "MTrk"

    track_length = midi.byteslice(position + 4, 4).unpack1("N")
    position += 8
    track_end = position + track_length
    tick = 0
    events = []
    while position < track_end
      delta, position = read_variable_length(midi, position)
      tick += delta
      raise "expected MIDI meta event" unless midi.getbyte(position) == 0xFF

      type = midi.getbyte(position + 1)
      data_length, data_position = read_variable_length(midi, position + 2)
      payload = midi.byteslice(data_position, data_length)
      events << [tick, unpack ? payload.unpack(unpack) : payload.bytes] if type == wanted_type
      position = data_position + data_length
    end
    events
  end

  def read_variable_length(bytes, position)
    value = 0
    loop do
      byte = bytes.getbyte(position)
      position += 1
      value = (value << 7) | (byte & 0x7F)
      return [value, position] if (byte & 0x80).zero?
    end
  end
end
