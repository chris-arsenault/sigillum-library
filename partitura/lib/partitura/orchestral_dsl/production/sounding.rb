# frozen_string_literal: true

require_relative "sounding/helpers"
require_relative "sounding/profiles"
require_relative "sounding/maps"

module Sigillum
  module OrchestralDSL
    module Production
      # SOUNDING projections: derived from the notes themselves, never from
      # declared intent (roles, harmony strings, gesture prose). These are the
      # PRIMARY analytical readouts - they report what a listener would hear
      # and work identically on composed and converted/foreign music. The
      # declared-intent projections (roles/harmony/foreground/material_map/...)
      # are secondary: they verify assertions against this ground truth.
      module SoundingReadout
        PC = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
        PC_NAMES = %w[C C# D Eb E F F# G Ab A Bb B].freeze
        DYN_ORDER = %w[ppp pp p mp mf f ff fff].freeze
        DISSONANT = [1, 2, 6, 10, 11].freeze


        include Helpers
        include Maps
        include Profiles
      end
    end
  end
end
