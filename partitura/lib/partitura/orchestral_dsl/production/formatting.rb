# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module_function

      def format_duration(value)
        value = Rational(value)
        return value.numerator.to_s if value.denominator == 1

        text = format("%.4f", value.to_f).sub(/0+\z/, "").sub(/\.\z/, "")
        text.start_with?("0.") ? text.sub(/\A0/, "") : text
      end

      def event_token(event, marks: true)
        mark_text = marks && !event.marks.empty? ? "{#{event.marks.join(',')}}" : ""
        "#{event.pitch_label}:#{format_duration(event.duration)}#{mark_text}"
      end

      def timed_event_line(piece, event)
        bits = [
          piece.format_offset(event.offset),
          event.part.to_s,
          event_token(event, marks: false),
          "role=#{event.role}",
          "phrase=#{event.phrase_id}"
        ]
        bits << "marks={#{event.marks.join(',')}}" unless event.marks.empty?
        bits << "transform=#{event.transform.inspect}" if event.transform
        bits << "realization=#{event.realization.inspect}" if event.realization
        bits.join("  ")
      end

      def control_summary(control)
        target = Array(control.target).join(",")
        case control.kind
        when :dynamic, :pedal, :text
          "#{control.kind} #{control.value} at #{control.at} for #{target}"
        else
          "#{control.kind} from #{control.from} to #{control.to} for #{target}"
        end
      end

      def tempo_summary(event)
        case event.kind
        when :mark, :a_tempo
          "#{event.kind} #{event.text.inspect} at #{event.at}"
        else
          "#{event.kind} from #{event.from} to #{event.to}"
        end
      end

      def meter_summary(event)
        pattern = event.beat_pattern ? " beat_pattern=#{event.beat_pattern.inspect}" : ""
        "#{event.meter} at bar #{event.bar}#{pattern}"
      end
    end
  end
end
