# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class Readout
        include SoundingReadout

        # Declared-intent views read authored assertions (roles, harmony prose,
        # gesture text, phrase ids), not the sounding result. They are SECONDARY:
        # useful to verify assertions against the music, silent on converted or
        # undeclared music. The sounding projections are primary.
        SECONDARY_VIEWS = %i[structure roles phrases placements staff_bars foreground
                             bass_path harmony harmony_with_melody material_map gesture_map].freeze
        SECONDARY_BANNER = "# [secondary/declared-intent view: reads authored assertions, not the sounding result."                            " Prefer the sounding projections: adjacency_profile recurrence_map peak_axes rhythm_profile"                            " articulation_map breath_map implied_harmony ensemble_grid exposed_clashes verticals line grid]"

        def initialize(piece)
          @piece = piece
        end

        def render(view, part: nil, bars: nil)
          bars = Production.parse_bar_range(bars) if bars.is_a?(String)
          body = render_view(view, part: part, bars: bars)
          return "#{SECONDARY_BANNER}\n#{body}" if SECONDARY_VIEWS.include?(view.to_sym)

          body
        end

        def render_view(view, part: nil, bars: nil)
          case view.to_sym
          when :structure
            structure
          when :roles
            roles(bars: bars)
          when :phrases
            phrases
          when :placements
            placements
          when :timed_events
            timed_events(bars: bars)
          when :verticals
            verticals(bars: bars)
          when :staff_bars
            staff_bars(bars: bars)
          when :foreground
            foreground(bars: bars)
          when :bass_path
            bass_path(bars: bars)
          when :line
            raise ArgumentError, "production line view requires part:" unless part

            line(part, bars: bars)
          when :harmony
            harmony(bars: bars)
          when :harmony_with_melody
            harmony_with_melody(bars: bars)
          when :grid
            grid(bars: bars)
          when :controls
            controls
          when :material_map
            material_map
          when :gesture_map
            gesture_map
          when :transport
            JSON.pretty_generate(Production.transport_hash(@piece))
          when :compile
            JSON.pretty_generate(@piece.compile_response)
          when :adjacency_profile
            adjacency_profile(part: part, bars: bars)
          when :recurrence_map
            recurrence_map_sounding(part: part, bars: bars)
          when :peak_axes
            peak_axes(bars: bars)
          when :rhythm_profile
            rhythm_profile(part: part, bars: bars)
          when :articulation_map
            articulation_map(part: part, bars: bars)
          when :breath_map
            breath_map(part: part, bars: bars)
          when :implied_harmony
            implied_harmony(bars: bars)
          when :ensemble_grid
            ensemble_grid(bars: bars)
          when :exposed_clashes
            exposed_clashes(bars: bars)
          when :bar_profile
            bar_profile(part: part, bars: bars)
          when :figure_timeline
            figure_timeline(part: part, bars: bars)
          else
            raise ArgumentError, "unknown production view #{view.inspect}"
          end
        end

        def structure
          lines = ["# #{@piece.title}", "meter: #{@piece.meter_value}", "key: #{@piece.key_value}"]
          @piece.meter_timeline.drop(1).each { |event| lines << "meter_change: #{Production.meter_summary(event)}" }
          @piece.tempo_marks.each { |tempo| lines << "tempo: #{tempo}" }
          @piece.controls.each { |control| lines << "control: #{Production.control_summary(control)}" }
          lines << ""
          @piece.sections.each do |section|
            lines << "#{section.id}: #{section.name} bars #{section.bars.begin}-#{section.bars.end}"
            section.journey_texts.each { |text| lines << "  journey: #{text}" }
            section.destination_texts.each { |text| lines << "  destination: #{text}" }
            section.spans.each do |span|
              lines << "  span bars #{span.bars.begin}-#{span.bars.end} texture=#{span.texture}"
              span.harmony_texts.each { |text| lines << "    harmony: #{text}" }
              span.process_texts.each { |text| lines << "    process: #{text}" }
              lines << "    phrases: #{span.phrases.keys.join(', ')}"
              lines << "    placements: #{span.placements.map { |p| "#{p.phrase_id}->#{p.part}@#{p.bar}:#{Production.format_duration(p.beat)}" }.join(', ')}"
              lines << "    staff_bars: #{span.staff_bars.map(&:number).join(', ')}"
            end
          end
          lines.join("\n")
        end

        def roles(bars: nil)
          lines = ["# Roles"]
          each_span(bars: bars) do |section, span|
            lines << ""
            lines << "#{section.id} #{section.name} | bars #{span.bars.begin}-#{span.bars.end} texture=#{span.texture}"
            span.placements.group_by(&:role).each do |role, placements|
              lines << "  #{role}: #{placements.map { |p| "#{p.part}=#{p.phrase_id}@#{p.bar}:#{Production.format_duration(p.beat)}" }.join('  ')}"
            end
            span.staff_bars.each do |bar|
              next unless in_bars_number?(bar.number, bars)

              lines << "  checkpoint bar #{bar.number}: #{bar.lanes.map { |lane| "#{lane.role}=#{lane.part || '?'}" }.join('  ')}"
            end
          end
          lines.join("\n")
        end

        def phrases
          lines = ["# Phrases"]
          @piece.phrases.each_value do |phrase|
            lines << "#{phrase.id} surface=#{phrase.surface} duration=#{Production.format_duration(phrase.duration)}"
            lines << "  #{phrase.events.map(&:to_s).join(' ')}"
          end
          lines.join("\n")
        end

        def placements
          lines = ["# Placements"]
          @piece.placements.each do |placement|
            line = "#{placement.phrase_id} -> #{placement.part} role=#{placement.role} at bar #{placement.bar} beat #{Production.format_duration(placement.beat)}"
            line += " transform=#{placement.transform.inspect}" if placement.transform
            line += " realization=#{placement.realization.inspect}" if placement.realization
            lines << line
          end
          lines.join("\n")
        end

        def timed_events(bars: nil)
          lines = ["# Timed Events"]
          @piece.timed_events.each do |event|
            next unless in_bars?(event.offset, bars)

            lines << Production.timed_event_line(@piece, event)
          end
          lines.join("\n")
        end

        def verticals(bars: nil)
          events = @piece.timed_events.select { |event| in_bars?(event.offset, bars) }
          offsets = events.map(&:offset).uniq.sort
          lines = ["# Verticals"]
          offsets.each do |offset|
            active = events.select { |event| event.offset <= offset && event.end_offset > offset && !event.rest? }
            next if active.empty?

            lines << @piece.format_offset(offset)
            active.group_by(&:role).each do |role, group|
              lines << "  #{role}: #{group.map { |event| "#{event.part}=#{event.pitch_label}" }.join('  ')}"
            end
          end
          lines.join("\n")
        end

        def staff_bars(bars: nil)
          lines = ["# Staff Bars"]
          @piece.staff_bars.each do |bar|
            next unless in_bars_number?(bar.number, bars)

            lines << "bar #{bar.number}"
            bar.checks.each { |check| lines << "  check: #{check}" }
            bar.lanes.each do |lane|
              part = lane.part ? "#{lane.part}: " : ""
              lines << "  #{lane.role}: #{part}#{lane.tokens.join(' ')}"
            end
          end
          lines.join("\n")
        end

        def foreground(bars: nil)
          lines = ["# Foreground"]
          matching_events(bars: bars, roles: %i[foreground lead melody]).each do |event|
            lines << Production.timed_event_line(@piece, event)
          end
          lines.join("\n")
        end

        def bass_path(bars: nil)
          lines = ["# Bass Path"]
          matching_events(bars: bars, roles: %i[bass bass_line ground]).each do |event|
            lines << Production.timed_event_line(@piece, event)
          end
          lines.join("\n")
        end

        def line(part, bars: nil)
          lines = ["# Line: #{part}"]
          @piece.timed_events(include_rests: true).each do |event|
            next unless event.part == part.to_sym
            next unless in_bars?(event.offset, bars)

            lines << Production.timed_event_line(@piece, event)
          end
          lines.join("\n")
        end

        def harmony(bars: nil)
          lines = ["# Harmony"]
          each_span(bars: bars) do |section, span|
            next if span.harmony_texts.empty?

            lines << "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
            span.harmony_texts.each { |text| lines << "  #{text}" }
          end
          lines.join("\n")
        end

        def harmony_with_melody(bars: nil)
          lines = ["# Harmony With Melody"]
          melody_events = matching_events(bars: bars, roles: %i[foreground lead melody answer])
          bass_events = matching_events(bars: nil, roles: %i[bass bass_line ground])
          melody_events.each do |event|
            harmony_text = harmony_at(event.offset)
            active_bass = bass_events.select do |bass|
              bass.offset <= event.offset && bass.end_offset > event.offset && !bass.rest?
            end
            bass_text =
              if active_bass.empty?
                "bass=(none)"
              else
                "bass=#{active_bass.map { |bass| "#{bass.part}=#{bass.pitch_label}" }.join(' ')}"
              end
            lines << "#{@piece.format_offset(event.offset)}  #{event.part}  #{event.pitch_label}:#{Production.format_duration(event.duration)}  harmony=#{harmony_text.inspect}  #{bass_text}  phrase=#{event.phrase_id}"
          end
          lines.join("\n")
        end

        def controls
          lines = ["# Controls"]
          @piece.anchors.each_value do |anchor|
            lines << "anchor #{anchor.id}=#{anchor.at}"
          end
          @piece.meter_timeline.each do |event|
            lines << "meter #{Production.meter_summary(event)}"
          end
          @piece.tempo_events.each do |event|
            lines << "tempo #{Production.tempo_summary(event)}"
          end
          @piece.controls.each do |control|
            lines << Production.control_summary(control)
          end
          lines.join("\n")
        end

        def material_map
          lines = ["# Material Map", "", "definitions:"]
          @piece.phrases.each_value do |phrase|
            lines << "- #{phrase.id}: surface=#{phrase.surface} duration=#{Production.format_duration(phrase.duration)}"
            lines << "  events: #{phrase.events.map(&:to_s).join(' ')}"
          end
          lines << ""
          lines << "uses:"
          @piece.placements.each do |placement|
            lines << "- #{placement.phrase_id} -> #{placement.part} role=#{placement.role} at bar #{placement.bar} beat #{Production.format_duration(placement.beat)}"
            lines << "  transform: #{placement.transform}" if placement.transform
            lines << "  realization: #{placement.realization}" if placement.realization
          end
          lines.join("\n")
        end

        def gesture_map
          lines = ["# Gesture Map"]
          @piece.sections.each do |section|
            section.gestures.each do |gesture|
              append_gesture(lines, gesture, "#{section.id} #{section.name}")
            end
            section.spans.each do |span|
              span.gestures.each do |gesture|
                append_gesture(lines, gesture, "#{section.id} bars #{span.bars.begin}-#{span.bars.end}")
              end
            end
          end
          lines.join("\n")
        end

        def grid(bars: nil)
          all_events = @piece.timed_events(include_rests: true)
          attack_offsets = all_events
            .reject(&:rest?)
            .select { |e| in_bars?(e.offset, bars) }
            .map(&:offset).uniq.sort
          return "# Score Grid\n(no events in range)" if attack_offsets.empty?

          parts    = @piece.parts.keys
          label_w  = parts.map { |p| p.to_s.length }.max + 1
          col_w    = 7

          fmt_hdr = lambda { |offset| @piece.format_offset(offset).delete_prefix("b") }
          cell_val = lambda do |part, offset|
            event = all_events.find do |e|
              e.part == part && e.offset <= offset && e.end_offset > offset
            end
            next "." unless event
            next "." if event.rest?
            event.offset == offset ? event.pitch_label : "~"
          end

          lines = ["# Score Grid#{bars ? " | bars #{bars.begin}-#{bars.end}" : ""}"]

          attack_offsets.each_slice(16) do |chunk|
            lines << ""
            hdr = " " * label_w + "|"
            chunk.each { |o| hdr += fmt_hdr.call(o).ljust(col_w) + "|" }
            lines << hdr
            lines << ("-" * hdr.length)

            parts.each do |part|
              cells = chunk.map { |o| cell_val.call(part, o) }
              next if cells.all? { |c| c == "." }
              row = part.to_s.ljust(label_w) + "|"
              cells.each { |c| row += c.ljust(col_w) + "|" }
              lines << row
            end
          end

          lines.join("\n")
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

        def matching_events(bars:, roles:)
          @piece.timed_events.select do |event|
            !event.rest? && in_bars?(event.offset, bars) && role_named?(event.role, *roles)
          end
        end

        def harmony_at(offset)
          contexts = []
          each_span do |_section, span|
            next if span.harmony_texts.empty?

            start_offset = @piece.offset_for(span.bars.begin, 1)
            end_offset = @piece.offset_for(span.bars.end + 1, 1)
            contexts.concat(span.harmony_texts) if offset >= start_offset && offset < end_offset
          end
          contexts.empty? ? "(none)" : contexts.join(" / ")
        end

        def append_gesture(lines, gesture, location)
          lines << ""
          lines << "#{location} | #{gesture.id}"
          lines << "  idea: #{gesture.idea_text}" if gesture.idea_text
          gesture.mechanism_texts.each { |text| lines << "  mechanism: #{text}" }
          gesture.audible_texts.each { |text| lines << "  audible: #{text}" }
          gesture.line_relations.each do |relation|
            lines << "  relation #{relation[:left]} <-> #{relation[:right]}: #{relation[:text]}"
          end
          gesture.orchestration_texts.each { |text| lines << "  orchestration: #{text}" }
          gesture.silence_texts.each { |text| lines << "  silence: #{text}" }
          gesture.note_texts.each { |text| lines << "  note: #{text}" }
          lines << "  mechanism: not written yet" unless gesture.supported?
        end

        def role_named?(role, *names)
          role_text = role.to_s
          tokens = role_text.split(/[_-]/)
          names.any? do |name|
            name_text = name.to_s
            role_text == name_text || tokens.include?(name_text)
          end
        end

        def in_bars?(offset, bars)
          return true unless bars

          bar = (offset / @piece.bar_length).floor + 1
          bars.include?(bar)
        end

        def in_bars_number?(number, bars)
          !bars || bars.include?(number)
        end

        def range_intersects?(left, right)
          return true unless right
          return right.any? { |n| left.cover?(n) } if right.is_a?(Array)

          left.begin <= right.end && right.begin <= left.end
        end
      end
    end
  end
end
