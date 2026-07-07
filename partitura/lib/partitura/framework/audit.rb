# frozen_string_literal: true

module Sigillum
  module Framework
    module Audit
      module_function

      DYNAMIC_MARKS = %w[ppp pp p mp mf f ff fff sf sfz fp].freeze
      TEMPO_MOTION_KINDS = %w[ritardando accelerando].freeze

      def dynamic_tempo(source_or_transport)
        transport = source_or_transport.is_a?(Hash) ? source_or_transport : Transport.hash_for(source_or_transport)
        context = dynamic_audit_context(transport)
        motions = tempo_motion_events(context.fetch(:tempo_events))
        atempos = atempo_events(context.fetch(:tempo_events))

        {
          "hist" => context.fetch(:hist),
          "missing_entrances" => missing_dynamic_entrances(context),
          "decels" => motions.map { |event| tempo_finding(event) },
          "atempos" => atempos.map { |event| tempo_finding(event) },
          "unresolved_tempo" => unresolved_tempo(motions, atempos),
          "total_bars" => total_bars(transport)
        }
      end

      def format_dynamic_tempo(findings)
        lines = ["## Dynamics + tempo audit (Ruby transport-measured)", ""]
        lines << "Dynamics: #{histogram_text(findings.fetch('hist', {}))}"
        lines << "Missing entrances: #{missing_entrance_text(findings)}"
        lines << "Tempo motion: #{finding_labels(findings.fetch('decels'))}"
        lines << "A tempo: #{finding_labels(findings.fetch('atempos'))}"
        lines << "Unresolved tempo: #{finding_labels(findings.fetch('unresolved_tempo'))}"
        lines << "Total bars: #{findings.fetch('total_bars')}"
        lines.join("\n")
      end

      def dynamic_audit_context(transport)
        dynamic_controls = dynamic_controls_for(transport)
        {
          parts: part_index(transport),
          timed_events: sorted_timed_events(transport),
          tempo_events: array_value(transport, :tempo_events),
          dynamic_controls: dynamic_controls,
          hist: dynamic_histogram(dynamic_controls)
        }
      end

      def dynamic_controls_for(transport)
        array_value(transport, :controls).select { |control| value(control, :kind).to_s == "dynamic" }
      end

      def sorted_timed_events(transport)
        array_value(transport, :timed_events).sort_by { |event| number_value(event, :offset_ql) }
      end

      def dynamic_histogram(dynamic_controls)
        dynamic_controls.each_with_object(Hash.new(0)) do |control, hist|
          hist[value(control, :value).to_s] += 1
        end
      end

      def tempo_motion_events(tempo_events)
        tempo_events.select { |event| TEMPO_MOTION_KINDS.include?(value(event, :kind).to_s) }
      end

      def atempo_events(tempo_events)
        tempo_events.select { |event| value(event, :kind).to_s == "a_tempo" }
      end

      def histogram_text(hist)
        return "none" if hist.empty?

        hist.sort.map { |dynamic, count| "#{dynamic}=#{count}" }.join(", ")
      end

      def missing_entrance_text(findings)
        missing = findings.fetch("missing_entrances")
        missing.empty? ? "none" : missing.length.to_s
      end

      def finding_labels(events)
        return "none" if events.empty?

        events.map { |event| event.fetch("label") }.join(", ")
      end

      def missing_dynamic_entrances(context)
        state = dynamic_entrance_state(context.fetch(:hist))
        context.fetch(:timed_events).each do |event|
          check_dynamic_entrance(event, context.fetch(:dynamic_controls), context.fetch(:parts), state)
        end
        state.fetch(:missing)
      end

      def dynamic_entrance_state(hist)
        {
          current_dynamic: {},
          applied_controls: Hash.new { |hash, key| hash[key] = {} },
          last_end: {},
          hist: hist,
          missing: []
        }
      end

      def check_dynamic_entrance(event, dynamic_controls, parts, state)
        part = value(event, :part).to_s
        return if part.empty?

        offset = number_value(event, :offset_ql)
        apply_dynamic_controls(part, offset, dynamic_controls, parts, state)
        local_dynamic = local_dynamic_for(event)
        state.fetch(:hist)[local_dynamic.to_s] += 1 if local_dynamic
        return if truthy?(value(event, :rest))

        record_missing_dynamic(event, part, offset, local_dynamic, state)
        record_dynamic_event_end(event, part, local_dynamic, state)
      end

      def local_dynamic_for(event)
        array_value(event, :local_marks).find { |mark| DYNAMIC_MARKS.include?(mark.to_s) }
      end

      def record_missing_dynamic(event, part, offset, local_dynamic, state)
        return unless missing_dynamic_entrance?(part, offset, local_dynamic, state)

        state.fetch(:missing) << missing_dynamic_entry(event, part)
      end

      def record_dynamic_event_end(event, part, local_dynamic, state)
        state.fetch(:current_dynamic)[part] = local_dynamic.to_s if local_dynamic
        last_end = state.fetch(:last_end)
        last_end[part] = [last_end[part] || 0.0, number_value(event, :end_offset_ql)].max
      end

      def missing_dynamic_entrance?(part, offset, local_dynamic, state)
        last_end = state.fetch(:last_end)
        entrance = !last_end.key?(part) || offset > last_end.fetch(part) + 0.0001
        entrance && local_dynamic.nil? && state.fetch(:current_dynamic)[part].nil?
      end

      def missing_dynamic_entry(event, part)
        {
          "part" => part,
          "offset_label" => value(event, :offset_label).to_s,
          "phrase_id" => value(event, :phrase_id).to_s,
          "pitch_label" => value(event, :pitch_label).to_s
        }
      end

      def apply_dynamic_controls(part, offset, dynamic_controls, parts, state)
        applied_controls = state.fetch(:applied_controls)
        dynamic_controls.each_with_index do |control, index|
          next if applied_controls[part][index]
          next unless target_applies?(value(control, :target), part, parts)
          next unless control_offset(control) <= offset + 0.0001

          state.fetch(:current_dynamic)[part] = value(control, :value).to_s
          applied_controls[part][index] = true
        end
      end

      def target_applies?(target, part, parts)
        return true if target.nil?

        type = value(target, :type).to_s
        return true if type == "all"

        part_data = parts.fetch(part, {})
        target_selectors(target, type).any? do |selector|
          selector_matches_part?(selector, part, part_data)
        end
      end

      def target_selectors(target, type)
        selectors = type == "list" ? array_value(target, :selectors) : [value(target, :selector)]
        selectors.compact.map(&:to_s)
      end

      def selector_matches_part?(selector, part, part_data)
        selector == part ||
          selector == value(part_data, :family).to_s ||
          selector == value(part_data, :notation_group).to_s
      end

      def unresolved_tempo(motions, atempos)
        atempo_offsets = atempos.map { |event| control_offset(event) }
        motions.reject do |motion|
          motion_end = number_value(motion, :to_offset_ql)
          atempo_offsets.any? { |offset| offset >= motion_end - 0.0001 }
        end.map { |event| tempo_finding(event) }
      end

      def tempo_finding(event)
        {
          "kind" => value(event, :kind).to_s,
          "label" => tempo_finding_label(event),
          "end_label" => value(event, :to_offset_label) || value(event, :to),
          "text" => value(event, :text),
          "bpm" => value(event, :bpm)
        }.compact
      end

      def tempo_finding_label(event)
        value(event, :offset_label) ||
          value(event, :from_offset_label) ||
          value(event, :at) ||
          value(event, :from)
      end

      def part_index(transport)
        array_value(transport, :parts).to_h { |part| [value(part, :id).to_s, part] }
      end

      def total_bars(transport)
        sections = array_value(transport, :sections)
        return sections.map { |section| value(value(section, :bars), :last).to_i }.max if sections.any?

        bar_length = number_value(transport, :bar_length_ql)
        return 0 if bar_length.zero?

        (number_value(transport, :total_duration_ql) / bar_length).ceil
      end

      def control_offset(control)
        number_value(control, :offset_ql, fallback: number_value(control, :from_offset_ql))
      end

      def value(hash, key)
        return nil unless hash.respond_to?(:[])

        hash[key] || hash[key.to_s]
      end

      def array_value(hash, key)
        Array(value(hash, key))
      end

      def number_value(hash, key, fallback: 0.0)
        raw = value(hash, key)
        raw.nil? ? fallback : raw.to_f
      end

      def truthy?(value)
        value == true || value.to_s == "true"
      end
    end
  end
end
