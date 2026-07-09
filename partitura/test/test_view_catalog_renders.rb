# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

# Guards found by the guided-workflow field test: every advertised view must actually
# render (a private renderer method crashes only at call time), key modes must survive
# into MusicXML, and lint must not report clean on a non-compiling source.
class ViewCatalogRendersTest < Minitest::Test
  def test_every_advertised_view_renders_on_the_flagship_study
    piece = Partitura.load_production_file(
      File.expand_path("../../experiments/partitura/production_hybrid_study.rb", __dir__)
    )
    catalog = Partitura::Production::Readout.view_catalog
    views = catalog.fetch(:sounding_views) + catalog.fetch(:data_views) +
            catalog.fetch(:secondary_declared_intent_views)
    views.each do |view|
      output = Partitura.production_readout(piece, view, part: :clarinet)
      refute_nil output, "view #{view} returned nil"
    end
  end

  def test_modal_and_minor_keys_export_real_musicxml_modes
    { "D dorian" => [0, "dorian"], "d" => [-1, "minor"], "F" => [-1, "major"],
      "c harmonic_minor" => [-3, "minor"], "g#" => [5, "minor"] }.each do |key_value, (fifths, mode)|
      xml = REXML::Document.new(Partitura.production_musicxml(keyed_piece(key_value)))
      assert_equal fifths.to_s, REXML::XPath.first(xml, "//key/fifths").text, "fifths for #{key_value}"
      assert_equal mode, REXML::XPath.first(xml, "//key/mode").text, "mode for #{key_value}"
    end
  end

  def test_lint_reports_compile_failure_instead_of_clean
    piece = Partitura::Production.piece("Broken") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :wall, surface: :split_pitch_rhythm do
            pitches "C5 D5 E5 F5 G5 A5"
            rhythm  "1 1 1 1 1 1"
          end
          placement :wall, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    readout = Partitura::Production::Lint.render(piece)
    assert_includes readout, "SOURCE DOES NOT COMPILE"
    assert_includes readout, "bar_onsets_cross_barline"
  end

  def test_recurrence_map_distinguishes_chords_by_all_members
    piece = Partitura::Production.piece("Dyads") do
      meter "4/4"
      roster { part :va, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :dyads, surface: :absolute do
            events "[A3,D4]:4 | [A3,C#4]:4"
          end
          placement :dyads, part: :va, at: "bar 1 beat 1", role: :inner
        end
      end
    end

    readout = Partitura.production_readout(piece, :recurrence_map)
    assert_includes readout, "exact repeats (pitch+rhythm): (none)"
  end

  def test_fermata_mark_renders_as_musicxml_notation_not_text
    piece = Partitura::Production.piece("Fermata") do
      meter "4/4"
      roster { part :vc, "Cello", music21: "Violoncello" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :cad, surface: :absolute do
            events "[D3,A3]:4{pp,fermata}"
          end
          placement :cad, part: :vc, at: "bar 1 beat 1", role: :bass_line
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
    xml = REXML::Document.new(Partitura.production_musicxml(piece))
    refute_nil REXML::XPath.first(xml, "//notations/fermata"), "expected a <fermata/> notation"
    assert_nil REXML::XPath.first(xml, "//words[text()='fermata']"), "fermata must not leak as text"
    Partitura.production_midi(piece)
  end

  def test_recurrence_map_reports_cross_part_returns
    piece = Partitura::Production.piece("Migrating ground") do
      meter "4/4"
      roster do
        part :vc, "Cello", music21: "Violoncello"
        part :vn, "Violin", music21: "Violin"
      end
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :ground, surface: :absolute do
            events "D3:1 F3:1 A3:1 D3:1"
          end
          phrase :ground_up, surface: :absolute do
            events "D5:1 F5:1 A5:1 D5:1"
          end
          placement :ground, part: :vc, at: "bar 1 beat 1", role: :bass
          placement :ground_up, part: :vn, at: "bar 2 beat 1", role: :foreground
        end
      end
    end

    readout = Partitura.production_readout(piece, :recurrence_map)
    assert_includes readout, "cross-part recurrences"
    assert_includes readout, "vc@b1 = vn@b2"
  end

  private

  def keyed_piece(key_value)
    Partitura::Production.piece("Key #{key_value}") do
      meter "4/4"
      key key_value
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :line, surface: :absolute do
            events "D5:4"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end
end
