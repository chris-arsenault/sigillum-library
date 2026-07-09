# frozen_string_literal: true

module Partitura
  module Production
    class FillMaterialBuilder
      def initialize(id, surface, default_key: nil)
        @id = id
        @surface = surface&.to_sym
        @default_key = default_key
        @fields = {}
      end

      def build(&block)
        instance_eval(&block) if block
        @surface ||= infer_surface
        FillMaterial.new(id: @id, surface: @surface, fields: @fields.dup, segment_counts: segment_counts,
                         default_key: @default_key)
      rescue CompileError => e
        raise e.with_context(fill_material: @id, surface: @surface)
      end

      def key_context(value)
        @fields[:key_context] = value.to_s
      end

      def anchor(value)
        @fields[:anchor] = value.to_s
      end

      def degrees(text)
        @fields[:degrees] = text.to_s
      end

      def intervals(text)
        @fields[:intervals] = text.to_s
      end

      def rhythm(text)
        @fields[:rhythm] = text.to_s
      end

      def events(text)
        @fields[:events] = text.to_s
      end

      private

      def infer_surface
        return :degrees if @fields.key?(:degrees)
        return :intervals if @fields.key?(:intervals)
        return :absolute if @fields.key?(:events)

        raise CompileError.new(
          code: "missing_fill_material_surface",
          message: "Fill material #{@id} has no surface.",
          repair_instruction: "Add surface: :degrees/:intervals/:absolute or a typed stream.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end

      def segment_counts
        text = @fields[:degrees] || @fields[:intervals] || @fields[:events]
        Production.token_bars(text).map(&:length) if text
      end
    end

    class FillTransformBuilder
      attr_reader :options

      def initialize(options = {})
        @options = options.dup
      end

      def build(&block)
        instance_eval(&block) if block
        @options
      end

      def transpose_to(value)
        @options[:transpose_to] = value.to_s
      end

      def transpose_by(value)
        @options[:transpose_by] = Integer(value)
      end

      def invert(axis: nil)
        @options[:invert] = true
        @options[:axis] = axis.to_s if axis
      end

      def retrograde
        @options[:retrograde] = true
      end

      def key_match(value)
        @options[:key_match] = value.to_s
      end
    end

    class FillMaterialRealizer
      # Reversal must also reverse spanner direction, or a slurred fill retrogrades
      # into `slur)` before `slur(` and exports broken notation.
      SPANNER_FLIP = %w[slur cresc dim gliss trill tie].to_h { |name| ["#{name}(", "#{name})"] }
                                                       .then { |open| open.merge(open.invert) }.freeze

      def initialize(material, options = {})
        @material = material
        @options = options
      end

      def realize(id: @material.id)
        events = base_events
        events = retrograde(events) if @options[:retrograde]
        events = invert(events, inversion_axis(events)) if @options[:invert]
        events = transpose(events, transpose_delta(events)) if transpose_delta(events)
        Phrase.new(id: id, surface: @material.surface, events: events, segment_counts: @material.segment_counts)
      end

      private

      def base_events
        fields = @material.fields
        case @material.surface
        when :degrees
          Production.events_from_degrees(fields.fetch(:degrees), fields.fetch(:rhythm),
                                         @options[:key_match] || fields[:key_context] ||
                                           @material.default_key || "C4")
        when :intervals
          Production.events_from_intervals(fields.fetch(:intervals), fields.fetch(:rhythm), fields.fetch(:anchor))
        when :absolute
          Production.events_from_absolute_events(fields.fetch(:events))
        else
          raise CompileError.new(
            code: "unsupported_fill_surface",
            message: "Fill material #{@material.id} surface #{@material.surface} is not supported.",
            repair_instruction: "Use degrees, intervals, or absolute fill material.",
            help_topic: "phrase_placement",
            docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
          )
        end
      end

      def retrograde(events)
        events.reverse.map { |event| clone_event(event, marks: flip_spanners(event.marks)) }
      end

      def flip_spanners(marks)
        marks.map { |mark| SPANNER_FLIP.fetch(mark, mark) }
      end

      def invert(events, axis)
        events.map { |event| clone_event(event, pitch: map_pitch(event.pitch) { |midi| (axis * 2) - midi }) }
      end

      def transpose(events, delta)
        events.map { |event| clone_event(event, pitch: map_pitch(event.pitch) { |midi| midi + delta }) }
      end

      def transpose_delta(events)
        return @options[:transpose_by] if @options.key?(:transpose_by)
        return nil unless @options[:transpose_to]

        first = first_midi(events)
        Production.pitch_to_midi(@options.fetch(:transpose_to)) - first
      end

      def inversion_axis(events)
        return Production.pitch_to_midi(@options.fetch(:axis)) if @options[:axis]

        first_midi(events)
      end

      def first_midi(events)
        pitch = events.reject(&:rest?).flat_map(&:pitches).first
        raise fill_transform_error("needs at least one pitched event") unless pitch

        Production.pitch_to_midi(pitch)
      end

      def map_pitch(pitch)
        return pitch if pitch.nil? || pitch == []

        if pitch.is_a?(Array)
          pitch.map { |value| Production.midi_to_pitch(yield(Production.pitch_to_midi(value))) }
        else
          Production.midi_to_pitch(yield(Production.pitch_to_midi(pitch)))
        end
      end

      def clone_event(event, pitch: event.pitch, marks: event.marks)
        Event.new(pitch: pitch, duration: event.duration, source: event.source, local_marks: marks)
      end

      def fill_transform_error(detail)
        CompileError.new(
          code: "bad_fill_transform",
          message: "Fill material #{@material.id} #{detail}.",
          repair_instruction: "Use a pitched fill before transpose_to/invert, or remove the transform.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end
    end
  end
end
