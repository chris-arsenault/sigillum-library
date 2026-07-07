# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionModeDegreesTest < Minitest::Test
  def test_lowercase_key_context_resolves_natural_minor
    events = Partitura::Production.events_from_degrees("1 2 3 4 5 6 7 1'", "1 1 1 1 1 1 1 1", "c4")
    assert_equal %w[C4 D4 Eb4 F4 G4 Ab4 Bb4 C5], events.map(&:pitch)
  end

  def test_raised_leading_tone_in_minor_uses_explicit_accidental
    events = Partitura::Production.events_from_degrees("5 #7 1'", "1 1 2", "c4")
    assert_equal %w[G4 B4 C5], events.map(&:pitch)
  end

  def test_explicit_mode_word_resolves_dorian
    events = Partitura::Production.events_from_degrees("1 3 6 7", "1 1 1 1", "D4 dorian")
    assert_equal %w[D4 F4 B4 C5], events.map(&:pitch)
  end

  def test_uppercase_key_context_stays_major
    events = Partitura::Production.events_from_degrees("1 3 5", "1 1 1", "F4")
    assert_equal %w[F4 A4 C5], events.map(&:pitch)
  end

  def test_unknown_mode_word_is_a_compile_error
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.events_from_degrees("1", "1", "C4 klingon")
    end
    assert_equal "bad_key_context", error.response.fetch(:code)
  end

  EXPECTED_MODE_SCALES = {
    "C4 major" => %w[C4 D4 E4 F4 G4 A4 B4],
    "C4 ionian" => %w[C4 D4 E4 F4 G4 A4 B4],
    "C4 minor" => %w[C4 D4 Eb4 F4 G4 Ab4 Bb4],
    "C4 aeolian" => %w[C4 D4 Eb4 F4 G4 Ab4 Bb4],
    "C4 harmonic_minor" => %w[C4 D4 Eb4 F4 G4 Ab4 B4],
    "C4 melodic_minor" => %w[C4 D4 Eb4 F4 G4 A4 B4],
    "C4 dorian" => %w[C4 D4 Eb4 F4 G4 A4 Bb4],
    "C4 phrygian" => %w[C4 Db4 Eb4 F4 G4 Ab4 Bb4],
    "C4 lydian" => %w[C4 D4 E4 F#4 G4 A4 B4],
    "C4 mixolydian" => %w[C4 D4 E4 F4 G4 A4 Bb4],
    "C4 locrian" => %w[C4 Db4 Eb4 F4 Gb4 Ab4 Bb4]
  }.freeze

  def test_every_supported_mode_resolves_its_scale
    EXPECTED_MODE_SCALES.each do |key_context, expected|
      events = Partitura::Production.events_from_degrees("1 2 3 4 5 6 7", "1 1 1 1 1 1 1", key_context)
      assert_equal expected, events.map(&:pitch), "wrong scale for #{key_context}"
    end
  end

  def test_span_level_key_sets_degree_default
    piece = Partitura::Production.piece("Span key") do
      meter "4/4"
      key "C"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          key "g"
          phrase :line, pitch: :degrees do
            degrees "1 3 5 1'"
            rhythm  "1 1 1 1"
          end
          placement :line, part: :vc, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_equal %w[G4 Bb4 D5 G5], piece.phrases.fetch(:line).events.map(&:pitch)
  end

  def test_section_level_key_sets_degree_default_for_spans
    piece = Partitura::Production.piece("Section key") do
      meter "4/4"
      key "C"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 1..1 do
        key "Eb"
        span bars: 1..1 do
          phrase :line, pitch: :degrees do
            degrees "1 3 5 r"
            rhythm  "1 1 1 1"
          end
          placement :line, part: :vc, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_equal %w[Eb4 G4 Bb4], piece.phrases.fetch(:line).events.map(&:pitch).compact
  end

  def test_key_change_with_silently_inherited_degrees_is_a_compile_error
    piece = modulating_piece(section_key: nil)
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "key_context_required", response.fetch(:code)
    assert_equal "g", response.fetch(:active_key)
  end

  def test_key_change_with_explicit_span_key_compiles
    piece = modulating_piece(section_key: "g")
    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_equal %w[G4 Bb4 D5], piece.phrases.fetch(:after_change).events.map(&:pitch).compact
  end

  def test_phrase_without_key_context_inherits_piece_key
    piece = Partitura::Production.piece("Inherit") do
      meter "4/4"
      key "c"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :line, pitch: :degrees do
            degrees "1 3 5 1'"
            rhythm  "1 1 1 1"
          end
          placement :line, part: :vc, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_equal %w[C4 Eb4 G4 C5], piece.phrases.fetch(:line).events.map(&:pitch)
    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  private

  # C major opening; key_change to g minor at bar 2; the bar-2 phrase either inherits
  # silently (must error) or sits under an explicit section key (must compile).
  def modulating_piece(section_key:)
    explicit_key = section_key
    Partitura::Production.piece("Modulation") do
      meter "4/4"
      key "C"
      roster { part :vc, "Cello", music21: "Violoncello" }
      control { key_change "g", at: "bar 2" }

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:opening, pitch: :degrees) { degrees "1 3 5 r"; rhythm "1 1 1 1" }
          placement :opening, part: :vc, at: "bar 1 beat 1", role: :foreground
        end
      end

      section :s2, "Two", bars: 2..2 do
        key explicit_key if explicit_key
        span bars: 2..2 do
          phrase(:after_change, pitch: :degrees) { degrees "1 3 5 r"; rhythm "1 1 1 1" }
          placement :after_change, part: :vc, at: "bar 2 beat 1", role: :foreground
        end
      end
    end
  end
end
