# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    ParseError = Class.new(StandardError)

    class Note
      attr_reader :pitch, :duration, :marks

      def initialize(pitch:, duration:, marks: [])
        @pitch = pitch
        @duration = duration
        @marks = marks.map(&:to_s)
      end

      def rest?
        @pitch.nil?
      end

      def chord?
        @pitch.is_a?(Array)
      end

      def sounding?
        !rest?
      end

      def pitch_label
        return "r" if rest?
        return "[#{@pitch.join(',')}]" if chord?

        @pitch.to_s
      end

      def duration_label
        if @duration.denominator == 1
          @duration.numerator.to_s
        else
          text = format("%.4f", @duration.to_f).sub(/0+\z/, "").sub(/\.\z/, "")
          text.start_with?("0.") ? text.sub(/\A0/, "") : text
        end
      end

      def to_s
        mark_text = @marks.empty? ? "" : "{#{@marks.join(',')}}"
        "#{pitch_label}:#{duration_label}#{mark_text}"
      end
    end

    class Part
      attr_reader :id, :name, :music21_instrument, :family, :range, :description

      def initialize(id:, name:, music21_instrument: nil, family: nil, range: nil, description: nil)
        @id = id.to_sym
        @name = name
        @music21_instrument = music21_instrument&.to_s
        @family = family&.to_sym
        @range = range
        @description = description
      end
    end

    class Material
      attr_reader :id, :description, :notes, :allowed_transforms

      def initialize(id:)
        @id = id.to_sym
        @description = nil
        @notes = []
        @allowed_transforms = []
      end

      attr_writer :description

      def add_notes(notes)
        @notes.concat(notes)
      end

      def allow_transform(text)
        @allowed_transforms << text.to_s
      end
    end

    class MaterialUse
      attr_reader :material_id, :transform, :comment, :notes

      def initialize(material_id:, transform: nil, comment: nil)
        @material_id = material_id.to_sym
        @transform = transform
        @comment = comment
        @notes = []
      end

      def add_notes(notes)
        @notes.concat(notes)
      end
    end

    LineItem = Struct.new(:note, :phrase, :material_use, keyword_init: true)

    class Line
      attr_reader :part_id, :role, :entry_offset, :technique, :items, :relations, :role_details,
                  :material_uses

      def initialize(part_id:, role:, entry_offset: 0, technique: nil)
        @part_id = part_id.to_sym
        @role = role.to_sym
        @entry_offset = Rational(entry_offset)
        @technique = technique
        @items = []
        @relations = []
        @role_details = []
        @material_uses = []
      end

      def add_notes(notes, phrase: nil, material_use: nil)
        notes.each do |note|
          @items << LineItem.new(note: note, phrase: phrase, material_use: material_use)
        end
        material_use&.add_notes(notes)
      end

      def add_relation(target_part, text)
        @relations << { target: target_part.to_sym, text: text.to_s }
      end

      def add_role_detail(text)
        @role_details << text.to_s
      end

      def add_material_use(material_use)
        @material_uses << material_use
      end
    end

    class Gesture
      attr_reader :id, :idea_text, :mechanism_texts, :audible_texts, :line_relations,
                  :orchestration_texts, :silence_texts, :note_texts

      def initialize(id:)
        @id = id.to_sym
        @idea_text = nil
        @mechanism_texts = []
        @audible_texts = []
        @line_relations = []
        @orchestration_texts = []
        @silence_texts = []
        @note_texts = []
      end

      attr_writer :idea_text

      def add_mechanism(text)
        @mechanism_texts << text.to_s
      end

      def add_audible(text)
        @audible_texts << text.to_s
      end

      def add_line_relation(left, right, text)
        @line_relations << { left: left.to_sym, right: right.to_sym, text: text.to_s }
      end

      def add_orchestration(text)
        @orchestration_texts << text.to_s
      end

      def add_silence(text)
        @silence_texts << text.to_s
      end

      def add_note(text)
        @note_texts << text.to_s
      end

      def supported?
        !@mechanism_texts.empty? || !@audible_texts.empty? || !@line_relations.empty? ||
          !@orchestration_texts.empty? || !@silence_texts.empty?
      end
    end

    class Moment
      attr_reader :bar, :beat, :label, :sonority_texts, :foreground_refs, :bass_refs,
                  :color_refs, :relation_texts

      def initialize(bar:, beat:, label: nil)
        @bar = Integer(bar)
        @beat = Rational(beat)
        @label = label
        @sonority_texts = []
        @foreground_refs = []
        @bass_refs = []
        @color_refs = []
        @relation_texts = []
      end

      def add_sonority(text)
        @sonority_texts << text.to_s
      end

      def add_foreground(part, pitch = nil)
        @foreground_refs << { part: part.to_sym, pitch: pitch }
      end

      def add_bass(part, pitch = nil)
        @bass_refs << { part: part.to_sym, pitch: pitch }
      end

      def add_color(part, text = nil)
        @color_refs << { part: part.to_sym, text: text }
      end

      def add_relation(text)
        @relation_texts << text.to_s
      end
    end

    class Span
      attr_reader :bars, :label, :texture, :harmony_texts, :process_texts, :lines, :gestures,
                  :moments

      def initialize(bars:, label: nil, texture: nil)
        @bars = bars
        @label = label
        @texture = texture&.to_sym
        @harmony_texts = []
        @process_texts = []
        @lines = []
        @gestures = []
        @moments = []
      end

      def add_harmony(text)
        @harmony_texts << text.to_s
      end

      def add_process(text)
        @process_texts << text.to_s
      end

      def add_line(line)
        @lines << line
      end

      def add_gesture(gesture)
        @gestures << gesture
      end

      def add_moment(moment)
        @moments << moment
      end
    end

    class Section
      attr_reader :id, :name, :bars, :type, :journey_texts, :destination_texts, :spans, :gestures

      def initialize(id:, name:, bars:, type: nil)
        @id = id.to_sym
        @name = name
        @bars = bars
        @type = type&.to_sym
        @journey_texts = []
        @destination_texts = []
        @spans = []
        @gestures = []
      end

      def add_journey(text)
        @journey_texts << text.to_s
      end

      def add_destination(text)
        @destination_texts << text.to_s
      end

      def add_span(span)
        @spans << span
      end

      def add_gesture(gesture)
        @gestures << gesture
      end
    end

    TimedNote = Struct.new(
      :section, :span, :line, :note, :offset, :phrase, :material_use,
      keyword_init: true
    ) do
      def duration
        note.duration
      end

      def sounding?
        note.sounding?
      end

      def end_offset
        offset + duration
      end
    end

    class Piece
      attr_reader :title, :meter_value, :beat_pattern, :bar_length, :key_value, :tempo_marks,
                  :parts, :materials, :sections

      def initialize(title:)
        @title = title
        @meter_value = "4/4"
        @beat_pattern = nil
        @bar_length = Rational(4)
        @key_value = nil
        @tempo_marks = []
        @parts = {}
        @materials = {}
        @sections = []
      end

      def set_meter(value, beat_pattern: nil, bar_length: nil)
        @meter_value = value.to_s
        @beat_pattern = beat_pattern
        @bar_length = bar_length ? Rational(bar_length) : meter_to_bar_length(@meter_value)
      end

      def set_key(value)
        @key_value = value.to_s
      end

      def add_tempo(text)
        @tempo_marks << text.to_s
      end

      def add_part(part)
        @parts[part.id] = part
      end

      def add_material(material)
        @materials[material.id] = material
      end

      def add_section(section)
        @sections << section
      end

      def part(id)
        @parts.fetch(id.to_sym)
      end

      def timed_notes(include_rests: false)
        notes = @sections.flat_map { |section| timed_section_notes(section, include_rests: include_rests) }
        notes.sort_by { |entry| [entry.offset, entry.line.part_id.to_s, entry.note.pitch_label] }
      end

      def timed_section_notes(section, include_rests:)
        section.spans.flat_map do |span|
          span.lines.flat_map { |line| timed_line_notes(section, span, line, include_rests: include_rests) }
        end
      end

      def timed_line_notes(section, span, line, include_rests:)
        offset = offset_for_bar(span.bars.begin) + line.entry_offset
        line.items.each_with_object([]) do |item, notes|
          notes << timed_note(section, span, line, item, offset) if include_rests || item.note.sounding?
          offset += item.note.duration
        end
      end

      def timed_note(section, span, line, item, offset)
        TimedNote.new(
          section: section,
          span: span,
          line: line,
          note: item.note,
          offset: offset,
          phrase: item.phrase,
          material_use: item.material_use
        )
      end

      def offset_for_bar(bar)
        Rational(bar - 1) * @bar_length
      end

      def format_offset(offset)
        bar = (offset / @bar_length).floor + 1
        beat = offset - offset_for_bar(bar) + 1
        "b#{bar}:#{format_rational(beat)}"
      end

      def bars_range
        first = @sections.map { |section| section.bars.begin }.min || 1
        last = @sections.map { |section| section.bars.end }.max || first
        first..last
      end

      private

      def meter_to_bar_length(value)
        match = value.match(%r{\A(\d+)/(\d+)\z})
        raise ParseError, "meter must look like '4/4', got #{value.inspect}" unless match

        Rational(match[1].to_i * 4, match[2].to_i)
      end

      def format_rational(value)
        if value.denominator == 1
          value.numerator.to_s
        else
          text = format("%.4f", value.to_f).sub(/0+\z/, "").sub(/\.\z/, "")
          text.start_with?("0.") ? text.sub(/\A0/, "") : text
        end
      end
    end
  end
end
