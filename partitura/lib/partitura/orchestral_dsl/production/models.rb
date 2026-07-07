# frozen_string_literal: true

require_relative "models/entities"
require_relative "models/compile_response"
require_relative "models/timing"
require_relative "models/validation"

module Sigillum
  module OrchestralDSL
    module Production
      class Piece
        include CompileResponse
        include Timing
        include Validation

        attr_reader :title, :meter_value, :beat_pattern, :bar_length, :key_value, :tempo_marks,
                    :meter_changes, :tempo_events, :anchors, :controls, :key_changes, :parts, :sections

        def initialize(title)
          @title = title
          @meter_value = "4/4"
          @beat_pattern = nil
          @bar_length = Rational(4)
          @key_value = "C"
          @meter_changes = []
          @tempo_marks = []
          @tempo_events = []
          @anchors = {}
          @controls = []
          @key_changes = []
          @parts = {}
          @sections = []
        end

        def set_meter(value, beat_pattern: nil)
          @meter_value = value.to_s
          @beat_pattern = beat_pattern
          @bar_length = Production.meter_to_bar_length(@meter_value)
        end

        def add_meter_change(value, at:, beat_pattern: nil)
          bar = Production.parse_bar_boundary(at)
          if bar == 1
            set_meter(value, beat_pattern: beat_pattern)
            return
          end

          @meter_changes << MeterEvent.new(
            meter: value.to_s,
            beat_pattern: beat_pattern,
            bar: bar
          )
        end

        def set_key(value)
          @key_value = value.to_s
        end

        def add_tempo(text, at: "bar 1 beat 1")
          @tempo_marks << text.to_s
          @tempo_events << TempoEvent.new(
            kind: :mark,
            text: text.to_s,
            at: at,
            bpm: Production.bpm_from_text(text)
          )
        end

        def add_tempo_event(event)
          @tempo_events << event
        end

        def add_anchor(id, at:)
          @anchors[id.to_sym] = Anchor.new(id: id.to_sym, at: at)
        end

        def add_control(control)
          @controls << control
        end

        def add_key_change(key_change)
          @key_changes << key_change
        end

        def add_part(part)
          @parts[part.id] = part
        end

        def add_section(section)
          @sections << section
        end

        def phrases
          out = {}
          origins = {}
          @sections.each do |section|
            section.spans.each do |span|
              span.phrase_definitions.each do |phrase|
                id = phrase.id
                if out.key?(id)
                  first_origin = origins.fetch(id)
                  second_origin = "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
                  raise compile_error(
                    code: "duplicate_phrase_id",
                    message: "Phrase id #{id} is defined more than once: #{first_origin} and #{second_origin}.",
                    repair_instruction: "Rename phrases so every phrase id is unique across the production piece.",
                    help_topic: "phrase_placement",
                    docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
                  )
                end
                out[id] = phrase
                origins[id] = "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
              end
            end
          end
          out
        end

        def placements
          @sections.flat_map { |section| section.spans.flat_map(&:placements) }
        end

        def staff_bars
          @sections.flat_map { |section| section.spans.flat_map(&:staff_bars) }
        end

        def gestures
          @sections.flat_map { |section| section.gestures + section.spans.flat_map(&:gestures) }
        end

        def total_duration
          return 0 if @sections.empty?

          @sections.map { |section| offset_for(section.bars.end + 1, 1) }.max
        end

        def offset_for(bar, beat)
          bar = Integer(bar)
          offset = Rational(0)
          (1...bar).each { |number| offset += bar_length_for(number) }
          offset + Rational(beat) - 1
        end

        def offset_for_reference(reference)
          case reference
          when Symbol
            anchor = @anchors.fetch(reference) do
              raise compile_error(
                code: "unknown_anchor",
                message: "Location references unknown anchor #{reference}.",
                repair_instruction: "Declare the anchor before using it in a control or tempo event.",
                help_topic: "controls",
                docs: ["docs/architecture/orchestral_dsl/surfaces/controls.md"]
              )
            end
            offset_for_reference(anchor.at)
          when String
            bar, beat = Production.parse_location(reference)
            offset_for(bar, beat)
          else
            Rational(reference)
          end
        end

        def timed_events(include_rests: false)
          phrase_map = phrases
          placements.flat_map do |placement|
            timed_events_for_placement(placement, phrase_map, include_rests: include_rests)
          end.sort_by { |event| [event.offset, event.part.to_s, event.pitch.to_s] }
        end

        def validate!
          validate_meter_events!
          validate_spans_and_placements!
          events = timed_events(include_rests: true)
          validate_tempo_events!
          validate_controls!(events)
          validate_key_changes!
        end

        def format_offset(offset)
          offset = Rational(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = bar_length_for(bar)
            break if offset < bar_start + length

            bar_start += length
            bar += 1
          end
          beat = offset - offset_for(bar, 1) + 1
          "b#{bar}:#{Production.format_duration(beat)}"
        end

        def meter_timeline
          [MeterEvent.new(meter: @meter_value, beat_pattern: @beat_pattern, bar: 1)] +
            @meter_changes.sort_by(&:bar)
        end

        def meter_for(bar)
          meter_timeline.select { |event| event.bar <= bar }.max_by(&:bar)
        end

        def bar_length_for(bar)
          Production.meter_to_bar_length(meter_for(Integer(bar)).meter)
        end

        private

        def compile_error(**kwargs)
          CompileError.new(**kwargs)
        end

      end
    end
  end
end
