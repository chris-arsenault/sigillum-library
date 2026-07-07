# frozen_string_literal: true

require_relative "voice_layout/items"
require_relative "voice_layout/rendered_parts"
require_relative "voice_layout/score_position"

module Partitura
  module Export
    module MusicXML
      module VoiceLayout
        include Items
        include RenderedParts
        include ScorePosition
      end
    end
  end
end
