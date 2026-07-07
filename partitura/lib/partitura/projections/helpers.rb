# frozen_string_literal: true

module Partitura
  module ProjectionHelpers
    private

    def each_span(bars: nil)
      @piece.sections.each do |section|
        section.spans.each do |span|
          next unless range_intersects?(span.bars, bars)

          yield section, span
        end
      end
    end

    def append_gesture(out, gesture, location)
      out << ""
      out << "#{location} | #{gesture.id}"
      out << "  idea: #{gesture.idea_text}" if gesture.idea_text
      append_gesture_texts(out, gesture)
      append_gesture_relations(out, gesture)
      out << "  mechanism: not written yet" unless gesture.supported?
    end

    def append_gesture_texts(out, gesture)
      {
        mechanism: gesture.mechanism_texts,
        audible: gesture.audible_texts,
        orchestration: gesture.orchestration_texts,
        silence: gesture.silence_texts,
        note: gesture.note_texts
      }.each do |label, texts|
        texts.each { |text| out << "  #{label}: #{text}" }
      end
    end

    def append_gesture_relations(out, gesture)
      gesture.line_relations.each do |relation|
        out << "  relation #{relation[:left]} <-> #{relation[:right]}: #{relation[:text]}"
      end
    end

    def timed_note_line(entry)
      bits = [
        @piece.format_offset(entry.offset),
        entry.line.part_id.to_s,
        entry.note.to_s,
        "role=#{entry.line.role}"
      ]
      bits << "phrase=#{entry.phrase.inspect}" if entry.phrase
      append_material_bits(bits, entry.material_use) if entry.material_use
      bits.join("  ")
    end

    def append_material_bits(bits, material_use)
      bits << "from=#{material_use.material_id}"
      bits << "transform=#{material_use.transform.inspect}" if material_use.transform
    end

    def role_named?(role, *names)
      role_text = role.to_s
      tokens = role_text.split(/[_-]/)
      names.any? do |name|
        name_text = name.to_s
        role_text == name_text || tokens.include?(name_text)
      end
    end

    def range_label(range)
      "#{range.begin}-#{range.end}"
    end

    def in_bars?(offset, bars)
      return true unless bars

      bar = (offset / @piece.bar_length).floor + 1
      bars.include?(bar)
    end

    def range_intersects?(left, right)
      return true unless right

      left.begin <= right.end && right.begin <= left.end
    end
  end
end
