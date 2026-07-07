# frozen_string_literal: true

module Partitura
  module Production
    class Readout
      module DeclaredViews
        def structure
          lines = ["# #{@piece.title}", "meter: #{@piece.meter_value}", "key: #{@piece.key_value}"]
          @piece.meter_timeline.drop(1).each { |event| lines << "meter_change: #{Production.meter_summary(event)}" }
          @piece.tempo_marks.each { |tempo| lines << "tempo: #{tempo}" }
          @piece.controls.each { |control| lines << "control: #{Production.control_summary(control)}" }
          lines << ""
          @piece.sections.each { |section| append_section_structure(lines, section) }
          lines.join("\n")
        end

        def roles(bars: nil)
          lines = ["# Roles"]
          each_span(bars: bars) { |section, span| append_span_roles(lines, section, span, bars) }
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
          @piece.placements.each { |placement| lines << placement_line(placement) }
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
          lines = ["# Verticals"]
          vertical_offsets(bars).each { |offset| append_vertical(lines, offset) }
          lines.join("\n")
        end

        def staff_bars(bars: nil)
          lines = ["# Staff Bars"]
          @piece.staff_bars.each { |bar| append_staff_bar(lines, bar) if in_bars_number?(bar.number, bars) }
          lines.join("\n")
        end

        def foreground(bars: nil)
          role_lines("# Foreground", bars: bars, roles: %i[foreground lead melody])
        end

        def bass_path(bars: nil)
          role_lines("# Bass Path", bars: bars, roles: %i[bass bass_line ground])
        end

        def harmony(bars: nil)
          lines = ["# Harmony"]
          each_span(bars: bars) { |section, span| append_harmony_span(lines, section, span) }
          lines.join("\n")
        end

        def harmony_with_melody(bars: nil)
          lines = ["# Harmony With Melody"]
          melody_events = matching_events(bars: bars, roles: %i[foreground lead melody answer])
          bass_events = matching_events(bars: nil, roles: %i[bass bass_line ground])
          chords = @piece.declared_chords
          current_bar = nil
          melody_events.each do |event|
            bar = bar_number_of(event.offset)
            if bar != current_bar
              lines << harmony_bar_header(bar, chords)
              current_bar = bar
            end
            lines << harmony_melody_line(event, bass_events)
          end
          lines.join("\n")
        end

        def controls
          lines = ["# Controls"]
          @piece.anchors.each_value { |anchor| lines << "anchor #{anchor.id}=#{anchor.at}" }
          @piece.meter_timeline.each { |event| lines << "meter #{Production.meter_summary(event)}" }
          @piece.tempo_events.each { |event| lines << "tempo #{Production.tempo_summary(event)}" }
          @piece.controls.each { |control| lines << Production.control_summary(control) }
          lines.join("\n")
        end

        def material_map
          lines = ["# Material Map", "", "definitions:"]
          @piece.phrases.each_value { |phrase| append_material_definition(lines, phrase) }
          lines << ""
          lines << "uses:"
          @piece.placements.each { |placement| append_material_use(lines, placement) }
          lines.join("\n")
        end

        def gesture_map
          lines = ["# Gesture Map"]
          @piece.sections.each { |section| append_section_gestures(lines, section) }
          lines.join("\n")
        end

        private

        def append_section_structure(lines, section)
          lines << "#{section.id}: #{section.name} bars #{section.bars.begin}-#{section.bars.end}"
          section.journey_texts.each { |text| lines << "  journey: #{text}" }
          section.destination_texts.each { |text| lines << "  destination: #{text}" }
          section.spans.each { |span| append_span_structure(lines, span) }
        end

        def append_span_structure(lines, span)
          lines << "  span bars #{span.bars.begin}-#{span.bars.end} texture=#{span.texture}"
          span.harmony_texts.each { |text| lines << "    harmony: #{text}" }
          span.process_texts.each { |text| lines << "    process: #{text}" }
          lines << "    phrases: #{span.phrases.keys.join(', ')}"
          lines << "    placements: #{span.placements.map { |placement| placement_summary(placement) }.join(', ')}"
          lines << "    staff_bars: #{span.staff_bars.map(&:number).join(', ')}"
        end

        def append_span_roles(lines, section, span, bars)
          lines << ""
          lines << "#{section.id} #{section.name} | bars #{span.bars.begin}-#{span.bars.end} texture=#{span.texture}"
          span.placements.group_by(&:role).each do |role, placements|
            lines << "  #{role}: #{placements.map { |placement| role_placement_summary(placement) }.join('  ')}"
          end
          span.staff_bars.each { |bar| append_checkpoint_lane(lines, bar) if in_bars_number?(bar.number, bars) }
        end

        def append_vertical(lines, offset)
          active = vertical_active_events(offset)
          return if active.empty?

          lines << @piece.format_offset(offset)
          active.group_by(&:role).each do |role, group|
            lines << "  #{role}: #{group.map { |event| "#{event.part}=#{event.pitch_label}" }.join('  ')}"
          end
        end

        def append_staff_bar(lines, bar)
          lines << "bar #{bar.number}"
          bar.checks.each { |check| lines << "  check: #{check}" }
          bar.lanes.each do |lane|
            part = lane.part ? "#{lane.part}: " : ""
            lines << "  #{lane.role}: #{part}#{lane.tokens.join(' ')}"
          end
        end

        def append_harmony_span(lines, section, span)
          return if span.harmony_texts.empty?

          lines << "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
          span.harmony_texts.each { |text| lines << "  #{text}" }
        end

        def append_material_definition(lines, phrase)
          lines << "- #{phrase.id}: surface=#{phrase.surface} duration=#{Production.format_duration(phrase.duration)}"
          lines << "  events: #{phrase.events.map(&:to_s).join(' ')}"
        end

        def append_material_use(lines, placement)
          lines << "- #{placement_summary(placement)} role=#{placement.role}"
          lines << "  transform: #{placement.transform}" if placement.transform
          lines << "  realization: #{placement.realization}" if placement.realization
        end

        def append_section_gestures(lines, section)
          section.gestures.each { |gesture| append_gesture(lines, gesture, "#{section.id} #{section.name}") }
          section.spans.each do |span|
            location = "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
            span.gestures.each { |gesture| append_gesture(lines, gesture, location) }
          end
        end

        def append_checkpoint_lane(lines, bar)
          lane_text = bar.lanes.map { |lane| "#{lane.role}=#{lane.part || '?'}" }.join('  ')
          lines << "  checkpoint bar #{bar.number}: #{lane_text}"
        end

        def placement_line(placement)
          line = "#{placement_summary(placement)} role=#{placement.role}"
          line += " transform=#{placement.transform.inspect}" if placement.transform
          line += " realization=#{placement.realization.inspect}" if placement.realization
          line
        end

        def role_lines(title, bars:, roles:)
          lines = [title]
          matching_events(bars: bars, roles: roles).each { |event|
 lines << Production.timed_event_line(@piece, event) }
          lines.join("\n")
        end

        def harmony_bar_header(bar, chords)
          chord = chords[bar]
          return "-- b#{bar} chord=#{chord}" if chord

          prose = harmony_at(@piece.offset_for(bar, 1))
          prose ? "-- b#{bar} (span harmony: #{prose})" : "-- b#{bar} (no harmony declared)"
        end

        def bar_number_of(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = @piece.bar_length_for(bar)
            break if offset < bar_start + length

            bar_start += length
            bar += 1
          end
          bar
        end

        def harmony_melody_line(event, bass_events)
          parts = [
            "  #{@piece.format_offset(event.offset)}",
            event.part,
            "#{event.pitch_label}:#{Production.format_duration(event.duration)}",
            active_bass_text(event, bass_events),
            "phrase=#{event.phrase_id}"
          ]
          parts.join("  ")
        end

        def active_bass_text(event, bass_events)
          active = bass_events.select { |bass| bass_active_for_event?(bass, event) }
          return "bass=(none)" if active.empty?

          "bass=#{active.map { |bass| "#{bass.part}=#{bass.pitch_label}" }.join(' ')}"
        end

        def bass_active_for_event?(bass, event)
          bass.offset <= event.offset && bass.end_offset > event.offset && !bass.rest?
        end

        def vertical_offsets(bars)
          @piece.timed_events
                .select { |event| in_bars?(event.offset, bars) }
                .map(&:offset).uniq.sort
        end

        def vertical_active_events(offset)
          @piece.timed_events.select do |event|
            event.offset <= offset && event.end_offset > offset && !event.rest?
          end
        end

        def placement_summary(placement)
          "#{placement.phrase_id} -> #{placement.part} at bar #{placement.bar} " \
            "beat #{Production.format_duration(placement.beat)}"
        end

        def role_placement_summary(placement)
          "#{placement.part}=#{placement.phrase_id}@#{placement.bar}:#{Production.format_duration(placement.beat)}"
        end
      end
    end
  end
end
