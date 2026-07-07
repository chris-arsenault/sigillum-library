# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module_function

      def transport_hash(piece)
        piece.validate!
        transport_header(piece).merge(
          transport_timeline(piece),
          transport_content(piece),
          transport_projection(piece)
        )
      rescue CompileError => e
        e.response
      end

      def transport_header(piece)
        {
          schema: "sigillum.orchestral_dsl.transport",
          schema_version: 3,
          source_model: "production_hybrid",
          title: piece.title,
          meter: piece.meter_value,
          beat_pattern: piece.beat_pattern,
          bar_length_ql: rational_number(piece.bar_length)
        }
      end

      def transport_timeline(piece)
        {
          meter_events: piece.meter_timeline.map { |event| transport_meter_event(piece, event) },
          key: piece.key_value,
          key_changes: piece.key_changes.map { |kc| transport_key_change(piece, kc) },
          tempo_marks: piece.tempo_marks,
          tempo_events: piece.tempo_events.map { |event| transport_tempo_event(piece, event) },
          anchors: piece.anchors.values.map { |anchor| transport_anchor(piece, anchor) },
          controls: piece.controls.map { |control| transport_control(piece, control) },
          total_duration_ql: rational_number(piece.total_duration)
        }
      end

      def transport_content(piece)
        {
          parts: piece.parts.values.map { |part| transport_part(part) },
          sections: piece.sections.map { |section| transport_section(section, piece) },
          phrases: piece.phrases.values.map { |phrase| transport_phrase(phrase) },
          placements: transport_placements(piece),
          timed_events: piece.timed_events(include_rests: true).map { |event| transport_timed_event(piece, event) }
        }
      end

      def transport_projection(piece)
        {
          staff_bars: transport_staff_bars(piece),
          gestures: transport_gestures(piece)
        }
      end

      def transport_json(piece)
        JSON.pretty_generate(transport_hash(piece))
      end

      def transport_part(part)
        {
          id: part.id.to_s,
          name: part.name,
          music21_instrument: part.music21_instrument,
          family: part.family&.to_s,
          range: part.range,
          description: part.description,
          notation_group: part.notation_group&.to_s,
          notation_staff: part.notation_staff&.to_s
        }.compact
      end

      def transport_meter_event(piece, event)
        offset = piece.offset_for(event.bar, 1)
        {
          bar: event.bar,
          meter: event.meter,
          beat_pattern: event.beat_pattern,
          bar_length_ql: rational_number(Production.meter_to_bar_length(event.meter)),
          offset_ql: rational_number(offset),
          offset_label: piece.format_offset(offset)
        }.compact
      end

      def transport_section(section, piece)
        {
          id: section.id.to_s,
          name: section.name,
          type: section.type&.to_s,
          bars: range_transport(section.bars),
          start_offset_ql: rational_number(piece.offset_for(section.bars.begin, 1)),
          end_offset_ql: rational_number(piece.offset_for(section.bars.end + 1, 1)),
          journey: section.journey_texts,
          destination: section.destination_texts,
          spans: section.spans.map { |span| transport_span(span, piece) },
          gestures: section.gestures.map { |gesture| transport_gesture(gesture, section: section.id) }
        }.compact
      end

      def transport_span(span, piece)
        {
          bars: range_transport(span.bars),
          start_offset_ql: rational_number(piece.offset_for(span.bars.begin, 1)),
          end_offset_ql: rational_number(piece.offset_for(span.bars.end + 1, 1)),
          texture: span.texture&.to_s,
          harmony: span.harmony_texts,
          process: span.process_texts,
          phrases: span.phrases.keys.map(&:to_s),
          placements: span.placements.map { |placement| transport_placement(piece, placement) },
          staff_bars: span.staff_bars.map { |bar| transport_staff_bar(bar) },
          gestures: span.gestures.map { |gesture| transport_gesture(gesture) }
        }.compact
      end

      def transport_phrase(phrase)
        {
          id: phrase.id.to_s,
          surface: phrase.surface.to_s,
          duration_ql: rational_number(phrase.duration),
          events: phrase.events.map.with_index do |event, index|
            {
              index: index,
              pitch: event.pitch,
              pitches: event.pitches,
              pitch_label: event.pitch_label,
              event_type: event.event_type,
              rest: event.rest?,
              duration_ql: rational_number(event.duration),
              source: event.source,
              local_marks: event.marks
            }
          end
        }
      end

      def transport_placements(piece)
        piece.sections.flat_map do |section|
          section.spans.flat_map do |span|
            span.placements.map do |placement|
              transport_placement(piece, placement).merge(
                section: section.id.to_s,
                span_bars: range_transport(span.bars)
              )
            end
          end
        end
      end

      def transport_placement(piece, placement)
        offset = piece.offset_for(placement.bar, placement.beat)
        {
          phrase_id: placement.phrase_id.to_s,
          part: placement.part.to_s,
          role: placement.role.to_s,
          bar: placement.bar,
          beat: rational_number(placement.beat),
          offset_ql: rational_number(offset),
          offset_label: piece.format_offset(offset),
          transform: placement.transform,
          realization: placement.realization
        }.compact
      end

      def transport_timed_event(piece, event)
        {
          part: event.part.to_s,
          role: event.role.to_s,
          phrase_id: event.phrase_id.to_s,
          pitch: event.pitch,
          pitches: event.pitches,
          pitch_label: event.pitch_label,
          event_type: event.event_type,
          rest: event.rest?,
          duration_ql: rational_number(event.duration),
          offset_ql: rational_number(event.offset),
          end_offset_ql: rational_number(event.end_offset),
          offset_label: piece.format_offset(event.offset),
          source: event.source,
          local_marks: event.marks,
          transform: event.transform,
          realization: event.realization
        }.compact
      end

      def transport_anchor(piece, anchor)
        offset = piece.offset_for_reference(anchor.at)
        {
          id: anchor.id.to_s,
          at: anchor.at.to_s,
          offset_ql: rational_number(offset),
          offset_label: piece.format_offset(offset)
        }
      end

      def transport_key_change(piece, kc)
        offset = piece.offset_for_reference(kc.at)
        {
          key: kc.key,
          at: kc.at.to_s,
          offset_ql: rational_number(offset),
          offset_label: piece.format_offset(offset)
        }
      end

      def transport_control(piece, control)
        base = {
          kind: control.kind.to_s,
          value: control.value,
          target: transport_target(control.target)
        }.compact
        if control.at
          offset = piece.offset_for_reference(control.at)
          base.merge(
            at: control.at.to_s,
            offset_ql: rational_number(offset),
            offset_label: piece.format_offset(offset)
          )
        else
          from_offset = piece.offset_for_reference(control.from)
          to_offset = piece.offset_for_reference(control.to)
          base.merge(
            from: control.from.to_s,
            to: control.to.to_s,
            from_offset_ql: rational_number(from_offset),
            to_offset_ql: rational_number(to_offset),
            from_offset_label: piece.format_offset(from_offset),
            to_offset_label: piece.format_offset(to_offset)
          )
        end
      end

      def transport_tempo_event(piece, event)
        base = {
          kind: event.kind.to_s,
          text: event.text,
          bpm: event.bpm
        }.compact
        if event.at
          offset = piece.offset_for_reference(event.at)
          base.merge(
            at: event.at.to_s,
            offset_ql: rational_number(offset),
            offset_label: piece.format_offset(offset)
          )
        else
          from_offset = piece.offset_for_reference(event.from)
          to_offset = piece.offset_for_reference(event.to)
          base.merge(
            from: event.from.to_s,
            to: event.to.to_s,
            from_offset_ql: rational_number(from_offset),
            to_offset_ql: rational_number(to_offset),
            from_offset_label: piece.format_offset(from_offset),
            to_offset_label: piece.format_offset(to_offset)
          )
        end
      end

      def transport_target(target)
        case target
        when Array
          { type: "list", selectors: target.map(&:to_s) }
        when :all, "all"
          { type: "all" }
        else
          { type: "selector", selector: target.to_s }
        end
      end

      def transport_staff_bars(piece)
        piece.sections.flat_map do |section|
          section.spans.flat_map do |span|
            span.staff_bars.map do |bar|
              transport_staff_bar(bar).merge(section: section.id.to_s, span_bars: range_transport(span.bars))
            end
          end
        end
      end

      def transport_staff_bar(bar)
        {
          number: bar.number,
          checks: bar.checks,
          lanes: bar.lanes.map do |lane|
            {
              role: lane.role.to_s,
              part: lane.part&.to_s,
              tokens: lane.tokens
            }.compact
          end
        }
      end

      def transport_gestures(piece)
        piece.sections.flat_map do |section|
          section.gestures.map { |gesture| transport_gesture(gesture, section: section.id) } +
            section.spans.flat_map do |span|
              span.gestures.map do |gesture|
                transport_gesture(gesture, section: section.id, span_bars: range_transport(span.bars))
              end
            end
        end
      end

      def transport_gesture(gesture, section: nil, span_bars: nil)
        {
          id: gesture.id.to_s,
          section: section&.to_s,
          span_bars: span_bars,
          idea: gesture.idea_text,
          mechanism: gesture.mechanism_texts,
          audible: gesture.audible_texts,
          line_relations: gesture.line_relations.map do |relation|
            { left: relation[:left].to_s, right: relation[:right].to_s, text: relation[:text] }
          end,
          orchestration: gesture.orchestration_texts,
          silence: gesture.silence_texts,
          notes: gesture.note_texts
        }.compact
      end

      def range_transport(range)
        { first: range.begin, last: range.end }
      end

      def rational_number(value)
        Rational(value).to_f
      end

      def tempo_events_from_marks(marks)
        marks.filter_map do |mark|
          bpm = bpm_from_text(mark)
          next unless bpm

          { offset_ql: 0.0, bpm: bpm, text: mark.to_s }
        end
      end
    end
  end
end
