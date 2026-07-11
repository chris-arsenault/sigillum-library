# frozen_string_literal: true

require "tmpdir"
require "rexml/document"
require "rexml/xpath"
require_relative "support/production_surface_helpers"

class ProductionTexturesTest < Minitest::Test
  include ProductionSurfaceHelpers

  TEXTURE_SOURCE = <<~RUBY
    production_piece "Texture Demo" do
      meter "2/4"; key "e"
      roster do
        part :violin, "Violin", music21: "Violin", family: :strings, range: "G3-E7"
        part :cello, "Cello", music21: "Violoncello", family: :strings, range: "C2-G5"
        part :bass, "Bass", music21: "Contrabass", family: :strings, range: "E1-C4"
        part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, range: "F#3-E6"
      end
      section :s1, "Ladder", bars: 1..2 do
        span bars: 1..2 do
          texture :string_engine, bars: 1..2 do
            control { dynamic :mp, at: :start; crescendo from: :start, to: :end }
            score grid: :eighth do
              violin "E5 B5 G5 B5 | F5 C6 Ab5 C6"
              cello  "E3 _  B3 _  | F3 _  C4 _"
              bass   "E2 .  .  .  | F2 .  .  ."
            end
            line :call, part: :trumpet, role: :foreground, surface: :intervals do
              anchor "E5"
              intervals "0 +7 -5 +2 | +1 +7 -5 +2"
              rhythm ".5 .25 .25 1 | .5 .25 .25 1"
            end
          end
        end
      end
    end
  RUBY

  def test_texture_combines_score_grid_and_interval_melody
    piece = load_texture_piece
    xml = REXML::Document.new(Partitura.production_musicxml(piece))

    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_includes piece.compile_response.fetch(:surface_summary), "score_grid"
    assert_includes Partitura.production_readout(piece, :controls), "dynamic mp"
    assert_equal "Texture Demo", REXML::XPath.first(xml, "/score-partwise/work/work-title").text
    assert_equal "MThd", Partitura.production_midi(piece).byteslice(0, 4)
  end

  def test_score_grid_sustains_across_barlines_emit_complete_tie_chains
    piece = Partitura::Production.piece("Tie Chain") do
      meter "4/4"
      roster do
        part :viola, "Viola", music21: "Viola"
        part :cello, "Cello", music21: "Violoncello"
      end
      section :s1, "One", bars: 1..3 do
        span bars: 1..3 do
          texture :pad, bars: 1..3 do
            score grid: :quarter do
              viola "[C4,G4] _ _ _ | _ _ _ _ | _ _ C4 ."
              cello "C3 _ _ _ | _ _ _ _ | _ _ _ _"
            end
          end
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
    viola_marks = piece.timed_events(include_rests: true).select { |e| e.part == :viola }.map(&:marks)
    assert_equal [["tie("], ["tie)", "tie("], ["tie)"], [], []], viola_marks

    xml = Partitura.production_musicxml(piece)
    assert_equal xml.scan(/tied type=.start/).length, xml.scan(/tied type=.stop/).length
    assert_equal 6, xml.scan(/tied type=.start/).length
  end

  # Slot mismatches are deferred: the piece loads (views render best-effort with a
  # COMPILE BLOCKED banner) and compile/export fail on the recorded error.
  def test_slot_count_mismatch_defers_but_fails_compile_with_lane_and_bar
    piece = texture_piece_with_lane("C4 _ _ | E4 _ _ _")
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "score_grid_slot_mismatch", response.fetch(:code)
    assert_equal "texture", response.fetch(:help_topic)
    assert_includes response.fetch(:message), "lane viola"
    assert_includes response.fetch(:message), "bar 1 of the lane has 3 slots"
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/texture.md"

    readout = Partitura.production_readout(piece, :ensemble_grid, bars: 1..1)
    assert_includes readout, "COMPILE BLOCKED"
    assert_includes readout, "score_grid_slot_mismatch"
    assert_includes readout, "--- b1"
  end

  def test_grid_parse_errors_carry_texture_and_lane_context
    error = assert_raises(Partitura::Production::CompileError) do
      texture_piece_with_lane("_ C4 _ _ | C4 _ _ _")
    end
    response = error.response
    assert_equal "bad_score_grid", response.fetch(:code)
    assert_equal "pad", response.fetch(:texture).to_s
    assert_equal "viola", response.fetch(:lane).to_s
  end

  def test_grid_that_does_not_divide_the_meter_fails_compile_but_loads
    piece = Partitura::Production.piece("Odd meter") do
      meter "7/8", beat_pattern: [3, 2, 2]
      roster { part :viola, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          texture :pad, bars: 1..1 do
            score(grid: :quarter) { viola "C4 _ _ _" }
          end
        end
      end
    end
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bad_score_grid", response.fetch(:code)
    assert_includes response.fetch(:message), "does not divide bar 1"
  end

  def test_tie_continuations_read_as_sustains_in_sounding_projections
    piece = suspension_piece
    grid = Partitura.production_readout(piece, :ensemble_grid, bars: 2..2)
    viola_row = grid.lines.find { |line| line.include?("viola") }
    assert viola_row.strip.split(/\s+/).last.start_with?("----|"),
           "tie continuation must render as sustain, got: #{viola_row}"

    clashes = Partitura.production_readout(piece, :exposed_clashes, bars: 2..2)
    refute_includes clashes, "both-atk", "a suspension held by tie is not a double attack:\n#{clashes}"

    profile = Partitura.production_readout(piece, :rhythm_profile, part: :viola)
    assert_includes profile, "2:1", "tied 1+1 must merge to one 2-beat event: #{profile}"
  end

  def test_triplet_grid_compiles_and_exports
    piece = Partitura::Production.piece("Triplets") do
      meter "4/4"
      roster { part :viola, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          texture :spin, bars: 1..1 do
            score(grid: :eighth_triplet) { viola "C4 E4 G4 C5 G4 E4 C4 E4 G4 C5 G4 E4" }
          end
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_equal "MThd", Partitura.production_midi(piece).byteslice(0, 4)
    assert_includes Partitura.production_musicxml(piece), "<work-title>Triplets</work-title>"
  end

  def test_texture_help_topic_is_routed
    data = Partitura::JITDocs.data(:texture)
    assert_equal :texture, data.fetch(:topic)
    assert_equal :texture, Partitura::JITDocs.data(:score_grid).fetch(:topic)
    assert_includes Partitura::JITDocs.data(:decision).fetch(:next_topics), :texture
  end

  private

  # Viola holds a tie across the barline (a suspension) while the cello moves.
  def suspension_piece
    Partitura::Production.piece("Suspension") do
      meter "4/4"
      roster do
        part :viola, "Viola", music21: "Viola"
        part :cello, "Cello", music21: "Violoncello"
      end
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :held, surface: :split_pitch_rhythm do
            pitches "C4 D4{tie(} | D4{tie)} C4"
            rhythm  "3 1 | 1 3"
          end
          phrase :bass, surface: :absolute do
            pitch_bars  "C3 | E2"
            rhythm_bars "4 | 4"
          end
          placement :held, part: :viola, at: "bar 1 beat 1", role: :foreground
          placement :bass, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end

  def texture_piece_with_lane(text)
    lane_text = text
    Partitura::Production.piece("Lane Probe") do
      meter "4/4"
      roster { part :viola, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          texture :pad, bars: 1..2 do
            score(grid: :quarter) { viola lane_text }
          end
        end
      end
    end
  end

  def load_texture_piece
    Dir.mktmpdir do |dir|
      path = File.join(dir, "texture.rb")
      File.write(path, TEXTURE_SOURCE)
      return Partitura.load_production_file(path)
    end
  end
end
