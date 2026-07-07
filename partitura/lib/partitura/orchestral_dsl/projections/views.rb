# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module ProjectionViews
      def summary
        out = summary_header
        out << ""
        out << "parts:"
        @piece.parts.each_value { |part| out << summary_part_line(part) }
        out << ""
        out << "sections:"
        @piece.sections.each { |section| out << summary_section_line(section) }
        out.join("\n")
      end

      def roles(bars: nil)
        out = ["# Role Map"]
        each_span(bars: bars) { |section, span| append_role_span(out, section, span) }
        out.join("\n")
      end

      def foreground(bars: nil)
        notes = notes_for_roles(bars: bars, roles: %i[foreground lead melody])
        projection_note_lines("# Foreground", notes)
      end

      def bass_path(bars: nil)
        notes = notes_for_roles(bars: bars, roles: %i[bass bass_line ground])
        projection_note_lines("# Bass Path", notes)
      end

      def line(part_id, bars: nil)
        out = ["# Line: #{part_id}"]
        current_span = nil
        entries_for_part(part_id, bars).each do |entry|
          current_span = append_line_span_header(out, entry, current_span)
          out << "  #{timed_note_line(entry)}"
        end
        out.join("\n")
      end

      def verticals(bars: nil)
        out = ["# Verticals"]
        vertical_attack_offsets(bars).each { |offset| append_vertical(out, offset) }
        out.join("\n")
      end

      def material_map
        out = ["# Material Map", "", "definitions:"]
        @piece.materials.each_value { |material| append_material_definition(out, material) }
        out << ""
        out << "uses:"
        @piece.sections.each { |section| append_section_material_uses(out, section) }
        out.join("\n")
      end

      def gesture_map
        out = ["# Gesture Map"]
        @piece.sections.each { |section| append_section_gestures(out, section) }
        out.join("\n")
      end

      private

      def summary_header
        out = ["# #{@piece.title}", "meter: #{@piece.meter_value}"]
        out << "beat pattern: #{@piece.beat_pattern.inspect}" if @piece.beat_pattern
        out << "key: #{@piece.key_value}" if @piece.key_value
        out << "tempo: #{@piece.tempo_marks.join('; ')}" unless @piece.tempo_marks.empty?
        out
      end

      def summary_part_line(part)
        detail = [part.family, part.range].compact.join(", ")
        "- #{part.id}: #{part.name}#{detail.empty? ? '' : " (#{detail})"}"
      end

      def summary_section_line(section)
        "- #{section.id}: #{section.name}, bars #{range_label(section.bars)}" \
          "#{section.type ? ", type #{section.type}" : ""}"
      end

      def append_role_span(out, section, span)
        out << ""
        out << role_span_header(section, span)
        span.harmony_texts.each { |text| out << "  harmony: #{text}" }
        span.process_texts.each { |text| out << "  process: #{text}" }
        span.lines.group_by(&:role).each { |role, lines| append_role_group(out, role, lines) }
      end

      def role_span_header(section, span)
        "#{section.id} #{section.name} | bars #{range_label(span.bars)}" \
          "#{span.texture ? " | texture #{span.texture}" : ""}"
      end

      def append_role_group(out, role, lines)
        out << "  #{role}: #{lines.map(&:part_id).join(', ')}"
        lines.each { |line| append_role_line_details(out, line) }
      end

      def append_role_line_details(out, line)
        line.role_details.each { |detail| out << "    #{line.part_id}: #{detail}" }
        line.relations.each do |relation|
          out << "    #{line.part_id} -> #{relation[:target]}: #{relation[:text]}"
        end
      end

      def notes_for_roles(bars:, roles:)
        @piece.timed_notes.select do |entry|
          entry.sounding? && role_named?(entry.line.role, *roles) && in_bars?(entry.offset, bars)
        end
      end

      def projection_note_lines(title, notes)
        out = [title]
        notes.each { |entry| out << timed_note_line(entry) }
        out.join("\n")
      end

      def entries_for_part(part_id, bars)
        @piece.timed_notes(include_rests: true).select do |entry|
          entry.line.part_id == part_id.to_sym && in_bars?(entry.offset, bars)
        end
      end

      def append_line_span_header(out, entry, current_span)
        span_key = [entry.section.id, entry.span.object_id, entry.line.role]
        return current_span if span_key == current_span

        out << ""
        out << "#{entry.section.id} #{entry.section.name} | bars #{range_label(entry.span.bars)} " \
               "| role #{entry.line.role}"
        span_key
      end

      def vertical_attack_offsets(bars)
        sounding = @piece.timed_notes.select(&:sounding?)
        sounding.map(&:offset).uniq.sort.select { |offset| in_bars?(offset, bars) }
      end

      def append_vertical(out, offset)
        active = active_vertical_notes(offset)
        return if active.empty?

        out << @piece.format_offset(offset)
        active.group_by { |entry| entry.line.role }.each { |role, entries| append_vertical_role(out, role, entries) }
      end

      def active_vertical_notes(offset)
        @piece.timed_notes.select do |entry|
          entry.sounding? && entry.offset <= offset && entry.end_offset > offset
        end
      end

      def append_vertical_role(out, role, entries)
        labels = entries.map { |entry| "#{entry.line.part_id}=#{entry.note.pitch_label}" }
        out << "  #{role}: #{labels.join('  ')}"
      end

      def append_material_definition(out, material)
        out << "- #{material.id}: #{material.description}"
        out << "  notes: #{material.notes.map(&:to_s).join(' ')}" unless material.notes.empty?
        material.allowed_transforms.each { |text| out << "  allowed transform: #{text}" }
      end

      def append_section_material_uses(out, section)
        section.spans.each do |span|
          span.lines.each do |line|
            line.material_uses.each { |use| append_material_use(out, section, span, line, use) }
          end
        end
      end

      def append_material_use(out, section, span, line, use)
        out << "- #{section.id} bars #{range_label(span.bars)} #{line.part_id}: #{use.material_id}" \
               "#{use.transform ? " | #{use.transform}" : ""}"
        out << "  #{use.comment}" if use.comment
        out << "  materialized: #{use.notes.map(&:to_s).join(' ')}" unless use.notes.empty?
      end

      def append_section_gestures(out, section)
        section.gestures.each { |gesture| append_gesture(out, gesture, "#{section.id} #{section.name}") }
        section.spans.each do |span|
          span.gestures.each { |gesture| append_gesture(out, gesture, "#{section.id} bars #{range_label(span.bars)}") }
        end
      end
    end
  end
end
