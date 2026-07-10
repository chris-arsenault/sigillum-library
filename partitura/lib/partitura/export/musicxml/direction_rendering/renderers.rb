# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module DirectionRendering
        module Renderers
          private

          def render_measure_event(xml, event)
            return render_dynamic_event(xml, event) if event.fetch(:kind) == :dynamic
            return render_text_event(xml, event) if %i[words tempo hidden_tempo].include?(event.fetch(:kind))
            return render_line_event(xml, event) if %i[wedge pedal harp_pedals].include?(event.fetch(:kind))

            render_harmony_event(xml, event)
          end

          def render_harmony_event(xml, event)
            return unless event.fetch(:kind) == :harmony

            render_harmony(xml, event.fetch(:value), offset: event.fetch(:local_offset))
          end

          def render_dynamic_event(xml, event)
            render_dynamic_direction(
              xml,
              event.fetch(:value),
              staff: event[:staff],
              offset: event.fetch(:local_offset),
              other: event[:other]
            )
          end

          def render_text_event(xml, event)
            case event.fetch(:kind)
            when :words
              render_words_direction(
                xml,
                event.fetch(:value),
                staff: event[:staff],
                offset: event.fetch(:local_offset)
              )
            when :tempo
              render_tempo_direction(
                xml,
                event.fetch(:bpm),
                event[:text],
                offset: event.fetch(:local_offset),
                beat_unit: event[:beat_unit] || "quarter",
                beat_unit_dots: event[:beat_unit_dots] || 0,
                per_minute: event[:per_minute] || event.fetch(:bpm)
              )
            when :hidden_tempo
              render_hidden_tempo_direction(xml, event.fetch(:bpm), offset: event.fetch(:local_offset))
            end
          end

          def render_line_event(xml, event)
            case event.fetch(:kind)
            when :wedge
              render_wedge_event(xml, event)
            when :pedal
              render_pedal_event(xml, event)
            when :harp_pedals
              render_harp_pedals_direction(
                xml,
                event.fetch(:value),
                staff: event[:staff],
                offset: event.fetch(:local_offset)
              )
            end
          end

          def render_pedal_event(xml, event)
            render_pedal_direction(
              xml,
              event.fetch(:value),
              staff: event[:staff],
              offset: event.fetch(:local_offset),
              number: event[:number]
            )
          end

          def render_wedge_event(xml, event)
            render_wedge_direction(
              xml,
              event.fetch(:value),
              staff: event[:staff],
              offset: event.fetch(:local_offset),
              number: event[:number],
              spread: event[:spread]
            )
          end
        end
      end
    end
  end
end
