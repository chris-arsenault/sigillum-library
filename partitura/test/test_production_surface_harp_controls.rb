# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceHarpControlsTest < Minitest::Test
  include ProductionSurfaceHelpers

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
    assert_equal(["D,C,B,E,F,G,A", "D#,C#,B#,E#,F#,G#,A#"], pedal_controls.map { |control| control.fetch(:value) })
    assert_equal([0.0, 4.0], pedal_controls.map { |control| control.fetch(:offset_ql) })
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

end
