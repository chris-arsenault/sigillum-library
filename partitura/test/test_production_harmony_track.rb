# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionHarmonyTrackTest < Minitest::Test
  def test_chords_declaration_builds_a_per_bar_track
    piece = harmony_piece
    assert_equal({ 1 => "F", 2 => "Bb", 3 => "C7", 4 => "F" }, piece.declared_chords)
  end

  def test_harmony_microformat_routes_to_chord_track
    piece = Partitura::Production.piece("Auto") do
      meter "4/4"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 17..18 do
        span bars: 17..18 do
          harmony "b17:Am b18:E7"
          harmony "free prose stays commentary"
          phrase :b, surface: :absolute do
            events "A2:4 | E2:4"
          end
          placement :b, part: :vc, at: "bar 17 beat 1", role: :bass
        end
      end
    end

    assert_equal({ 17 => "Am", 18 => "E7" }, piece.declared_chords)
    span = piece.sections.first.spans.first
    assert_equal ["free prose stays commentary"], span.harmony_texts
  end

  def test_bad_chord_symbol_is_a_compile_error
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad chord") do
        meter "4/4"
        section :s1, "One", bars: 1..1 do
          span bars: 1..1 do
            chords "b1:Qmaj"
          end
        end
      end
    end
    assert_equal "bad_chord_track", error.response.fetch(:code)
  end

  def test_chord_bar_outside_span_is_a_compile_error
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad bar") do
        meter "4/4"
        section :s1, "One", bars: 1..2 do
          span bars: 1..2 do
            chords "b5:F"
          end
        end
      end
    end
    assert_equal "bad_chord_track", error.response.fetch(:code)
  end

  def test_harmony_check_diffs_declared_against_sounding
    readout = Partitura.production_readout(harmony_piece, :harmony_check)
    assert_includes readout, "b1: declared F"
    assert_includes readout, "match"
    assert_includes readout, "# Harmony Check"
  end

  def test_harmony_check_flags_silent_declared_bar
    piece = Partitura::Production.piece("Silent bar") do
      meter "4/4"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          chords "b1:F b2:Bb"
          phrase :b, surface: :absolute do
            events "F2:4"
          end
          placement :b, part: :vc, at: "bar 1 beat 1", role: :bass
        end
      end
    end

    readout = Partitura.production_readout(piece, :harmony_check)
    assert_includes readout, "b2: declared Bb; no sounding notes"
  end

  def test_harmony_with_melody_prints_chord_once_per_bar
    readout = Partitura.production_readout(harmony_piece, :harmony_with_melody, bars: 1..2)
    assert_includes readout, "-- b1 chord=F"
    assert_includes readout, "-- b2 chord=Bb"
    refute_includes readout, "harmony="
  end

  def test_melody_report_uses_declared_key
    report = Partitura.production_readout(harmony_piece, :melody_report, part: :fl)
    assert_includes report, "key F major (declared"
  end

  private

  def harmony_piece
    Partitura::Production.piece("Harmony Track") do
      meter "4/4"
      key "F"
      roster do
        part :fl, "Flute", music21: "Flute"
        part :vc, "Cello", music21: "Violoncello"
      end
      section :s1, "One", bars: 1..4 do
        span bars: 1..4 do
          chords "b1:F b2:Bb b3:C7 b4:F"
          phrase :tune, pitch: :degrees do
            degrees "1 2 3 5 | 4 3 2 1 | 5, 7, 2 4 | 3 1 r"
            rhythm  "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
          end
          phrase :bass, surface: :absolute do
            pitch_bars  "F2 C3 | Bb2 F3 | C3 G3 | F2"
            rhythm_bars "2 2 | 2 2 | 2 2 | 4"
          end
          placement :tune, part: :fl, at: "bar 1 beat 1", role: :foreground
          placement :bass, part: :vc, at: "bar 1 beat 1", role: :bass_line
        end
      end
    end
  end
end
