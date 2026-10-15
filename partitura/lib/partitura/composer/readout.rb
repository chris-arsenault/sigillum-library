# frozen_string_literal: true

module Partitura
  module Composer
    class Readout
      def initialize(score)
        @score = score
      end

      def render(section: nil, passage: nil, voice: nil)
        return overview unless section

        selected = @score.section(section)
        return section_text(selected) unless passage

        music = @score.passage(section, passage)
        if voice
          value = music.fetch("voices").find { |item| item.fetch("id") == voice }
          raise Error.new("unknown_voice", "No voice named #{voice}.") unless value

          return voice_text(value)
        end
        [section_heading(selected), passage_text(music), neighbors(selected, music),
         decisions(section, passage)].reject(&:empty?).join("\n\n")
      end

      def overview
        data = @score.data
        opening = data.fetch("sections").first || data
        lines = ["# #{data.fetch('title')} (#{data.fetch('id')})", data.fetch("brief"),
                 "Opening: #{opening.fetch('meter', data.fetch('meter'))}; " \
                 "key #{opening.fetch('key', data.fetch('key'))}; #{opening.fetch('tempo', data.fetch('tempo'))}.",
                 "Forces:"]
        data.fetch("parts").each do |part|
          lines << "- #{part.fetch('id')}: #{part.fetch('name')} (#{part.fetch('instrument')}) " \
                   "#{part['range']}#{ensemble_label(part)}"
        end
        lines << "Form:"
        data.fetch("sections").each do |section|
          lines << section_heading(section)
          section.fetch("passages").each do |passage|
            lines << "  #{passage.fetch('id')}: local bars #{passage.fetch('at')}-" \
                     "#{passage.fetch('at') + passage.fetch('bars') - 1}; #{passage['purpose']}"
          end
        end
        lines.concat(coverage)
        lines << decisions
        lines.join("\n")
      end

      def section_heading(section)
        start = @score.section_start(section.fetch("id"))
        "#{section.fetch('id')}: #{section.fetch('name')} — bars #{start}-#{start + section.fetch('bars') - 1}; " \
          "#{section['meter']}; key #{section['key']}; #{section['tempo']}"
      end

      def ensemble_label(part)
        case part["ensemble"]
        when true then "; section (size unspecified)"
        when false then "; single player"
        when Integer then "; ensemble of #{part['ensemble']} players"
        else ""
        end
      end

      def section_text(section)
        [section_heading(section), section["journey"], section["destination"],
         *section.fetch("passages").map { |passage| passage_text(passage) },
         "Expressive timeline (section-local positions):",
         *section.fetch("controls").map { |control| control_text(control) },
         decisions(section.fetch("id"))].compact.join("\n\n")
      end

      def passage_text(passage)
        ["Passage #{passage.fetch('id')}: section-local bar #{passage.fetch('at')}, #{passage.fetch('bars')} bars.",
         passage["purpose"], "Harmony: #{passage['chords']} #{passage['harmony']}",
         *passage.fetch("voices").map { |voice| voice_text(voice) }].compact.join("\n\n")
      end

      def voice_text(voice)
        lines = ["Voice #{voice.fetch('id')}; part #{voice.fetch('part')}; role #{voice.fetch('role',
'foreground')}; " \
                 "entry #{voice.fetch('entry', 'bar 1 beat 1')} within the passage."]
        lines << "Pickup: #{voice['anacrusis']} quarter-note units." if voice["anacrusis"]
        if voice["events"]
          lines << voice.fetch("events")
        else
          lines.concat(["Key context: #{voice['key_context']}", "Degrees: #{voice['degrees']}",
                        "Rhythm: #{voice['rhythm']}"])
        end
        lines.join("\n")
      end

      def control_text(control)
        control.map { |key, value| "#{key}: #{value.is_a?(Array) ? value.join(', ') : value}" }.join("; ")
      end

      def decisions(section = nil, passage = nil)
        items = @score.data.fetch("decisions").select do |item|
          within_scope?(item, "section", section) && within_scope?(item, "passage", passage)
        end
        return "" if items.empty?

        "Settled musical decisions:\n" + items.map { |item| "- #{item.fetch('id')}: #{item.fetch('text')}" }.join("\n")
      end

      def neighbors(section, passage)
        index = section.fetch("passages").sort_by { |item| item.fetch("at") }
        position = index.index(passage)
        adjacent = [position.positive? && index[position - 1], index[position + 1]].select { |item| item }
        "Neighboring passages: " + adjacent.map { |item| "#{item['id']} (#{item['purpose']})" }.join("; ")
      end

      def within_scope?(item, field, scope)
        !scope || !item[field] || item[field] == scope
      end

      def coverage
        lines = []
        parts = @score.data.fetch("parts").map { |part| part.fetch("id") }
        lines << "No forces have been assigned." if parts.empty?
        lines << "No form has been written." if @score.data.fetch("sections").empty?
        @score.data.fetch("sections").each { |section| lines.concat(section_coverage(section, parts)) }
        lines
      end

      def section_coverage(section, parts)
        lines = []
        lines << "Unwritten section #{section['id']}." if section.fetch("passages").empty?
        covered = section.fetch("passages").flat_map do |passage|
          (passage.fetch("at")...(passage.fetch("at") + passage.fetch("bars"))).to_a
        end
        missing_bars = (1..section.fetch("bars")).to_a - covered
        lines << "Unwritten bars in #{section['id']}: #{missing_bars.join(', ')}." unless missing_bars.empty?
        section.fetch("passages").each do |passage|
          missing = parts - passage.fetch("voices").map { |voice| voice.fetch("part") }
          lines << "Unwritten in #{section['id']}/#{passage['id']}: #{missing.join(', ')}." unless missing.empty?
        end
        lines
      end
    end
  end
end
