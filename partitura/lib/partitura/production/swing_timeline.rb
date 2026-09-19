# frozen_string_literal: true

module Partitura
  module Production
    # One exact authored-to-realized clock for events, controls and projections.
    # Complete pairs swing 2:1; barlines and incomplete terminal pairs stay fixed.
    class SwingTimeline
      PERIODS = { eighth: Rational(1), sixteenth: Rational(1, 2), off: nil }.freeze
      DOCS = ["docs/architecture/partitura/surfaces/controls.md"].freeze

      def initialize(piece, override: nil)
        @piece = piece
        @override = override
        cursor = Rational(0)
        @bars = (1..(piece.sections.map { |section| section.bars.end }.max || 0)).map do |number|
          length = piece.bar_length_for(number)
          row = [cursor, cursor + length]
          cursor += length
          row
        end
        @changes = changes
        validate_changes!
      end

      def active?
        @override != :off && @changes.any? { |_at, mode| mode != :off }
      end

      def realize(event)
        return event unless active?

        [event.offset, event.end_offset].each do |offset|
          next unless cell_at(offset)
          denominator = Rational(offset).denominator
          next if (denominator & (denominator - 1)).zero?

          error("nonbinary_swing_timing", "#{event.part} #{event.pitch_label} has a nonbinary authored endpoint #{offset} while swing is active.",
                "Write straight binary durations in the active region, or switch swing off for literal tuplets.")
        end
        onset = offset(event.offset)
        finish = offset(event.end_offset)
        TimedEvent.new(**event.to_h.merge(offset: onset, duration: finish - onset))
      end

      def offset(value)
        value = Rational(value)
        cell = cell_at(value)
        return value unless cell

        start, period = cell
        phase = value - start
        midpoint = period / 2
        start + if phase <= midpoint
                  phase * Rational(4, 3)
                else
                  period * Rational(2, 3) + (phase - midpoint) * Rational(2, 3)
                end
      end

      private

      def changes
        grouped = @piece.controls.select { |control| control.kind.to_sym == :swing }
                        .group_by { |control| @piece.offset_for_reference(control.at) }
        grouped.sort.map do |at, controls|
          modes = controls.map { |control| control.value.to_sym }.uniq
          error("conflicting_swing_controls", "Conflicting swing declarations at #{at}.",
                "Keep one global swing mode at each location.") if modes.length != 1
          mode = modes.first
          error("bad_swing_mode", "Unknown swing mode #{mode.inspect}.",
                "Use swing :eighth, :sixteenth, or :off.") unless PERIODS.key?(mode)
          unless controls.all? { |control| control.target == :all }
            error("scoped_swing_control", "Swing must apply to all parts.", "Remove the part-specific swing target.")
          end
          [Rational(at), mode]
        end
      end

      def validate_changes!
        previous = :off
        @changes.each do |at, mode|
          unless at >= 0 && at <= @piece.total_duration
            error("bad_swing_location", "Swing location #{at} is outside the score.", "Place swing controls inside the score or at its end.")
          end
          bar = @bars.find { |start, finish| start <= at && at < finish }
          if bar && at != bar.first
            periods = [PERIODS[previous], PERIODS[mode]].compact
            unless periods.all? { |period| ((at - bar.first) / period).denominator == 1 }
              error("unaligned_swing_change", "Swing change at #{at} cuts an active pair.",
                    "Use a barline or a pair boundary shared by the old and new swing modes.")
            end
          end
          previous = mode
        end
      end

      def cell_at(value)
        return nil if @override == :off

        mode = @changes.reverse_each.find { |at, _| at <= value }&.last || :off
        period = PERIODS[mode]
        return nil unless period

        bar = @bars.bsearch { |_start, finish| value < finish }
        return nil if bar && value < bar.first
        return nil unless bar

        start = bar.first + ((value - bar.first) / period).floor * period
        return nil if start + period > bar.last

        [start, period]
      end

      def error(code, message, repair)
        raise CompileError.new(code: code, message: message, repair_instruction: repair,
                               help_topic: "controls", docs: DOCS)
      end
    end
  end
end
