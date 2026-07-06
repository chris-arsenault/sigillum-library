# frozen_string_literal: true

require_relative "model"

module Sigillum
  module OrchestralDSL
    class Projections
      def initialize(piece)
        @piece = piece
      end

      def render(name, part: nil, bars: nil)
        case name.to_sym
        when :summary
          summary
        when :roles
          roles(bars: bars)
        when :foreground
          foreground(bars: bars)
        when :verticals
          verticals(bars: bars)
        when :bass_path
          bass_path(bars: bars)
        when :material_map
          material_map
        when :gesture_map
          gesture_map
        when :line
          raise ArgumentError, "line projection requires part:" unless part

          line(part, bars: bars)
        when :all
          [
            summary,
            roles(bars: bars),
            foreground(bars: bars),
            bass_path(bars: bars),
            material_map,
            gesture_map
          ].join("\n\n")
        else
          raise ArgumentError, "unknown projection #{name.inspect}"
        end
      end

      def summary
        out = []
        out << "# #{@piece.title}"
        out << "meter: #{@piece.meter_value}"
        out << "beat pattern: #{@piece.beat_pattern.inspect}" if @piece.beat_pattern
        out << "key: #{@piece.key_value}" if @piece.key_value
        out << "tempo: #{@piece.tempo_marks.join('; ')}" unless @piece.tempo_marks.empty?
        out << ""
        out << "parts:"
        @piece.parts.each_value do |part|
          detail = [part.family, part.range].compact.join(", ")
          out << "- #{part.id}: #{part.name}#{detail.empty? ? '' : " (#{detail})"}"
        end
        out << ""
        out << "sections:"
        @piece.sections.each do |section|
          out << "- #{section.id}: #{section.name}, bars #{range_label(section.bars)}" \
                 "#{section.type ? ", type #{section.type}" : ""}"
        end
        out.join("\n")
      end

      def roles(bars: nil)
        out = ["# Role Map"]
        each_span(bars: bars) do |section, span|
          out << ""
          out << "#{section.id} #{section.name} | bars #{range_label(span.bars)}" \
                 "#{span.texture ? " | texture #{span.texture}" : ""}"
          span.harmony_texts.each { |text| out << "  harmony: #{text}" }
          span.process_texts.each { |text| out << "  process: #{text}" }
          grouped = span.lines.group_by(&:role)
          grouped.each do |role, lines|
            out << "  #{role}: #{lines.map { |line| line.part_id }.join(', ')}"
            lines.each do |line|
              line.role_details.each { |detail| out << "    #{line.part_id}: #{detail}" }
              line.relations.each do |relation|
                out << "    #{line.part_id} -> #{relation[:target]}: #{relation[:text]}"
              end
            end
          end
        end
        out.join("\n")
      end

      def foreground(bars: nil)
        out = ["# Foreground"]
        foreground_notes = @piece.timed_notes.select do |entry|
          entry.sounding? && role_named?(entry.line.role, :foreground, :lead, :melody) &&
            in_bars?(entry.offset, bars)
        end
        foreground_notes.each do |entry|
          out << timed_note_line(entry)
        end
        out.join("\n")
      end

      def bass_path(bars: nil)
        out = ["# Bass Path"]
        bass_notes = @piece.timed_notes.select do |entry|
          entry.sounding? && role_named?(entry.line.role, :bass, :bass_line, :ground) &&
            in_bars?(entry.offset, bars)
        end
        bass_notes.each do |entry|
          out << timed_note_line(entry)
        end
        out.join("\n")
      end

      def line(part_id, bars: nil)
        out = ["# Line: #{part_id}"]
        entries = @piece.timed_notes(include_rests: true).select do |entry|
          entry.line.part_id == part_id.to_sym && in_bars?(entry.offset, bars)
        end
        current_span = nil
        entries.each do |entry|
          span_key = [entry.section.id, entry.span.object_id, entry.line.role]
          if span_key != current_span
            current_span = span_key
            out << ""
            out << "#{entry.section.id} #{entry.section.name} | bars #{range_label(entry.span.bars)}" \
                   " | role #{entry.line.role}"
          end
          out << "  #{timed_note_line(entry)}"
        end
        out.join("\n")
      end

      def verticals(bars: nil)
        out = ["# Verticals"]
        sounding = @piece.timed_notes.select(&:sounding?)
        attacks = sounding.map(&:offset).uniq.sort.select { |offset| in_bars?(offset, bars) }
        attacks.each do |offset|
          active = sounding.select { |entry| entry.offset <= offset && entry.end_offset > offset }
          next if active.empty?

          out << "#{@piece.format_offset(offset)}"
          active.group_by { |entry| entry.line.role }.each do |role, entries|
            labels = entries.map { |entry| "#{entry.line.part_id}=#{entry.note.pitch_label}" }
            out << "  #{role}: #{labels.join('  ')}"
          end
        end
        out.join("\n")
      end

      def material_map
        out = ["# Material Map"]
        out << ""
        out << "definitions:"
        @piece.materials.each_value do |material|
          out << "- #{material.id}: #{material.description}"
          out << "  notes: #{material.notes.map(&:to_s).join(' ')}" unless material.notes.empty?
          material.allowed_transforms.each { |text| out << "  allowed transform: #{text}" }
        end
        out << ""
        out << "uses:"
        @piece.sections.each do |section|
          section.spans.each do |span|
            span.lines.each do |line|
              line.material_uses.each do |use|
                out << "- #{section.id} bars #{range_label(span.bars)} #{line.part_id}: #{use.material_id}" \
                       "#{use.transform ? " | #{use.transform}" : ""}"
                out << "  #{use.comment}" if use.comment
                out << "  materialized: #{use.notes.map(&:to_s).join(' ')}" unless use.notes.empty?
              end
            end
          end
        end
        out.join("\n")
      end

      def gesture_map
        out = ["# Gesture Map"]
        @piece.sections.each do |section|
          section.gestures.each do |gesture|
            append_gesture(out, gesture, "#{section.id} #{section.name}")
          end
          section.spans.each do |span|
            span.gestures.each do |gesture|
              append_gesture(out, gesture, "#{section.id} bars #{range_label(span.bars)}")
            end
          end
        end
        out.join("\n")
      end

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
        out << "  mechanism: #{gesture.mechanism_texts.join(' / ')}" unless gesture.mechanism_texts.empty?
        gesture.audible_texts.each { |text| out << "  audible: #{text}" }
        gesture.line_relations.each do |relation|
          out << "  relation #{relation[:left]} <-> #{relation[:right]}: #{relation[:text]}"
        end
        gesture.orchestration_texts.each { |text| out << "  orchestration: #{text}" }
        gesture.silence_texts.each { |text| out << "  silence: #{text}" }
        gesture.note_texts.each { |text| out << "  note: #{text}" }
        out << "  mechanism: not written yet" unless gesture.supported?
      end

      def timed_note_line(entry)
        bits = [
          @piece.format_offset(entry.offset),
          entry.line.part_id.to_s,
          entry.note.to_s,
          "role=#{entry.line.role}"
        ]
        bits << "phrase=#{entry.phrase.inspect}" if entry.phrase
        if entry.material_use
          bits << "from=#{entry.material_use.material_id}"
          bits << "transform=#{entry.material_use.transform.inspect}" if entry.material_use.transform
        end
        bits.join("  ")
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
end
