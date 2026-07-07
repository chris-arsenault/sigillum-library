# frozen_string_literal: true

require_relative "maps/articulation_breath"
require_relative "maps/clashes_stalls"
require_relative "maps/harmony_grid"
require_relative "maps/profiles"

module Partitura
  module Production
    module SoundingReadout
      module Maps
        include ArticulationBreath
        include ClashesStalls
        include HarmonyGrid
        include Profiles
      end
    end
  end
end
