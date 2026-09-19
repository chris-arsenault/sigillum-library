# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      # Scoped notation dynamics for the perceptual model. Levels are model dB,
      # not MIDI velocities or measured sound pressure. Explicit marks reset the
      # level; hairpins interpolate to the next explicit mark within their span,
      # or move 6 dB over a complete unquantified span. The endpoint persists.
      class PerceptualDynamics
        LEVELS = {
          "ppp" => -33, "pp" => -27, "p" => -21, "mp" => -15,
          "mf" => -9, "f" => -3, "ff" => 3, "fff" => 6
        }.freeze
        DEFAULT = -9
        Segment = Struct.new(:from, :to, :first, :last, keyword_init: true) do
          def at(offset)
            return first if to.infinite?

            first + (last - first) * ((offset - from).to_f / (to - from))
          end
        end

        def initialize(piece)
          @piece = piece
          @segments = piece.parts.keys.to_h { |part| [part, build(part)] }
        end

        def level(part, offset)
          segment = @segments.fetch(part).reverse_each.find { |item| item.from <= offset }
          segment ? segment.at(offset) : DEFAULT
        end

        private

        def targets(control, part)
          Array(control.target).any? do |target|
            key = target.to_sym
            key == :all || key == part || key == @piece.parts.fetch(part).family&.to_sym
          end
        end

        def points(part)
          values = {}
          @piece.controls.each do |control|
            next unless control.kind.to_s == "dynamic" && targets(control, part)
            next unless LEVELS.key?(control.value.to_s)

            values[@piece.realized_offset_for_reference(control.at)] = LEVELS.fetch(control.value.to_s)
          end
          # Local marks take precedence at the same offset. Include rests and
          # tie continuations: their written dynamic affects subsequent sound.
          @piece.timed_events(include_rests: true).each do |event|
            next unless event.part == part

            mark = event.marks.map(&:to_s).find { |value| LEVELS.key?(value) || value == "fp" }
            values[event.offset] = mark == "fp" ? LEVELS.fetch("p") : LEVELS.fetch(mark) if mark
          end
          values.sort.to_h
        end

        def ramps(part)
          controls = @piece.controls.filter_map do |control|
            next unless %w[crescendo diminuendo].include?(control.kind.to_s) && targets(control, part)

            [@piece.realized_offset_for_reference(control.from), @piece.realized_offset_for_reference(control.to),
             control.kind.to_s == "crescendo" ? 6.0 : -6.0]
          end
          open = {}
          @piece.timed_events(include_rests: true).select { |event| event.part == part }.sort_by(&:offset).each do |event|
            event.marks.map(&:to_s).each do |mark|
              if %w[cresc( dim(].include?(mark)
                open[mark[0..-2]] = event.offset
              elsif %w[cresc) dim)].include?(mark)
                kind = mark[0..-2]
                from = open.delete(kind)
                controls << [from, event.offset, kind == "cresc" ? 6.0 : -6.0] if from
              end
            end
          end
          controls.select { |from, to, _| to > from }.sort_by(&:first)
        end

        def build(part)
          marks = points(part)
          hairpins = ramps(part)
          boundaries = ([Rational(0)] + marks.keys + hairpins.flat_map { |from, to, _| [from, to] }).uniq.sort
          current = DEFAULT
          segments = boundaries.each_cons(2).map do |from, to|
            current = marks.fetch(from, current)
            ramp = hairpins.reverse_each.find { |start, finish, _| start <= from && from < finish }
            following = current
            if ramp
              start, finish, delta = ramp
              target = marks.find { |at, _| at > from && at <= finish }
              target_at, target_db = target || [finish, current + delta * (finish - from).to_f / (finish - start)]
              following += (target_db - current) * (to - from).to_f / (target_at - from)
            end
            segment = Segment.new(from: from, to: to, first: current, last: following)
            current = following
            segment
          end
          last = boundaries.last
          segments << Segment.new(from: last, to: Float::INFINITY, first: marks.fetch(last, current))
          segments
        end
      end
    end
  end
end
