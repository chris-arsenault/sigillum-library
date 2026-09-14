# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      # Seconds follow explicit, quarter-normalized tempo marks, as MIDI does.
      # Text-only ritardando/accelerando spans do not invent a playback curve.
      class PerceptualTiming
        def initialize(piece)
          points = { Rational(0) => 120.0 }
          piece.tempo_events.each do |event|
            next unless %w[mark playback].include?(event.kind.to_s) && event.at && event.bpm&.positive?

            points[piece.offset_for_reference(event.at)] = event.bpm.to_f
          end
          elapsed = 0.0
          ordered = points.sort
          @points = ordered.each_with_index.map do |(offset, bpm), index|
            previous = ordered[index - 1] if index.positive?
            elapsed += (offset - previous[0]).to_f * 60.0 / previous[1] if previous
            [offset, bpm, elapsed]
          end
        end

        def seconds_at(offset)
          at, bpm, seconds = @points.reverse_each.find { |point| point[0] <= offset } || @points.first
          seconds + (offset - at).to_f * 60.0 / bpm
        end

        def offset_at(seconds)
          at, bpm, elapsed = @points.reverse_each.find { |point| point[2] <= seconds } || @points.first
          at + (seconds - elapsed) * bpm / 60.0
        end
      end
    end
  end
end
