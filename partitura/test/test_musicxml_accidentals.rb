# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class MusicXMLAccidentalsTest < Minitest::Test
  def test_accidentals_reset_at_barline_and_cancel_within_the_same_octave
    doc = export_piece("F#4:1 F#4:1 F4:1 F#5:1 | F#4:1 F4:1 F##4:1 F#4:1", bars: 2)
    assert_equal ["sharp", nil, "natural", "sharp", "sharp", "natural", "double-sharp", "sharp"], accidentals(doc)
  end

  def test_key_signature_and_change_determine_required_naturals
    doc = export_piece("Bb4:1 B4:1 B4:1 Bb4:1 | Bb4:1 B4:1 F#4:1 F4:1", key: "F", bars: 2, change: "G")
    assert_equal [nil, "natural", nil, "flat", "flat", "natural", nil, "natural"], accidentals(doc)
  end

  def test_chord_alterations_and_tuplet_accidental_child_order
    doc = export_piece("r:23/6 [C#4,G4]:1/6")
    assert_equal ["sharp", nil], accidentals(doc)
    note = REXML::XPath.first(doc, "//note[accidental]")
    names = note.elements.to_a.map(&:name)
    assert_operator names.index("accidental"), :>, names.index("type")
    assert_operator names.index("accidental"), :<, names.index("time-modification")
  end

  def test_tie_continuation_does_not_need_or_establish_accidental
    doc = export_piece("r:3 F#4:1{tie(} | F#4:1{tie)} F#4:1 F4:2", bars: 2)
    assert_equal ["sharp", nil, "sharp", "natural"], accidentals(doc)
  end

  def test_written_transposition_uses_written_signature
    doc = export_piece("D4:1 D#4:1 D#4:1 D4:1", instrument: "Clarinet", key: "Bb")
    assert_equal %w[E E E E], REXML::XPath.match(doc, "//pitch/step").map(&:text)
    assert_equal [nil, "sharp", nil, "natural"], accidentals(doc)
  end

  def test_simultaneous_conflicting_chord_pitches_are_both_explicit
    doc = export_piece("[F4,F#4]:1 F#4:1 F#4:1 F4:1")
    assert_equal ["natural", "sharp", "sharp", nil, "natural"], accidentals(doc)
  end

  def test_voice_serialization_does_not_override_time_order_or_staff_independence
    renderer = Partitura::Export::MusicXML::Renderer.allocate
    renderer.instance_variable_set(:@current_rendered_index, 0)
    renderer.define_singleton_method(:rendered_parts) { [{ "family" => "string", "source_parts" => [] }] }
    renderer.define_singleton_method(:keyless_part?) { |_part| false }
    renderer.define_singleton_method(:key_at_bar) { |_bar| "C" }
    renderer.define_singleton_method(:written_key_fifths) { |_part, _key| 0 }
    renderer.define_singleton_method(:mapped_percussion_note) { |_pitch| [nil, nil] }
    renderer.define_singleton_method(:written_pitch) { |pitch| parse_pitch(pitch) }
    later = { local_offset: 2, staff: 1, pitches: ["F#4"] }
    earlier = { local_offset: 0, staff: 1, pitches: ["F#4"] }
    lower_staff = { local_offset: 2, staff: 2, pitches: ["F#4"] }
    renderer.send(:prepare_measure_accidentals, [[later], [earlier], [lower_staff]], { number: 1 })
    assert_equal({ 0 => "sharp" }, earlier[:accidentals])
    assert_empty later[:accidentals]
    assert_equal({ 0 => "sharp" }, lower_staff[:accidentals])
  end

  private

  def accidentals(doc)
    REXML::XPath.match(doc, "//note[pitch]").map { |note| note.elements["accidental"]&.text }
  end

  def export_piece(events, key: "C", bars: 1, change: nil, instrument: "Viola")
    piece = Partitura.production_piece("Accidental notation") do
      meter "4/4"
      key key
      roster { part :line, "Line", music21: instrument, family: :string }
      section :test, "Test", bars: 1..bars do
        span bars: 1..bars do
          phrase(:notes, surface: :absolute) { events events }
          placement :notes, part: :line, at: "bar 1 beat 1", role: :foreground
        end
      end
      control { key_signature change, at: "bar 2 beat 1", for: :line } if change
    end
    REXML::Document.new(Partitura::Export::MusicXML.render(piece))
  end
end
