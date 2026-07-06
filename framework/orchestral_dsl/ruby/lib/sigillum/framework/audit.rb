# frozen_string_literal: true

module Sigillum
  module Framework
    module Audit
      module_function

      DYNAMIC_MARKS = %w[ppp pp p mp mf f ff fff sf sfz fp].freeze
      TEMPO_MOTION_KINDS = %w[ritardando accelerando].freeze

      def dynamic_tempo(source_or_transport)
        transport = source_or_transport.is_a?(Hash) ? source_or_transport : Transport.hash_for(source_or_transport)
        parts = part_index(transport)
        controls = array_value(transport, :controls)
        timed_events = array_value(transport, :timed_events).sort_by { |event| number_value(event, :offset_ql) }
        tempo_events = array_value(transport, :tempo_events)

        dynamic_controls = controls.select { |control| value(control, :kind).to_s == "dynamic" }
        hist = Hash.new(0)
        dynamic_controls.each { |control| hist[value(control, :value).to_s] += 1 }

        missing = missing_dynamic_entrances(timed_events, dynamic_controls, parts, hist)
        motions = tempo_events.select { |event| TEMPO_MOTION_KINDS.include?(value(event, :kind).to_s) }
        atempos = tempo_events.select { |event| value(event, :kind).to_s == "a_tempo" }

        {
          "hist" => hist,
          "missing_entrances" => missing,
          "decels" => motions.map { |event| tempo_finding(event) },
          "atempos" => atempos.map { |event| tempo_finding(event) },
          "unresolved_tempo" => unresolved_tempo(motions, atempos),
          "total_bars" => total_bars(transport)
        }
      end

      def format_dynamic_tempo(findings)
        lines = ["## Dynamics + tempo audit (Ruby transport-measured)", ""]
        hist = findings.fetch("hist", {})
        lines << "Dynamics: #{hist.empty? ? 'none' : hist.sort.map { |dynamic, count| "#{dynamic}=#{count}" }.join(', ')}"
        lines << "Missing entrances: #{findings.fetch('missing_entrances').empty? ? 'none' : findings.fetch('missing_entrances').length}"
        lines << "Tempo motion: #{findings.fetch('decels').empty? ? 'none' : findings.fetch('decels').map { |event| event.fetch('label') }.join(', ')}"
        lines << "A tempo: #{findings.fetch('atempos').empty? ? 'none' : findings.fetch('atempos').map { |event| event.fetch('label') }.join(', ')}"
        lines << "Unresolved tempo: #{findings.fetch('unresolved_tempo').empty? ? 'none' : findings.fetch('unresolved_tempo').map { |event| event.fetch('label') }.join(', ')}"
        lines << "Total bars: #{findings.fetch('total_bars')}"
        lines.join("\n")
      end

      def missing_dynamic_entrances(timed_events, dynamic_controls, parts, hist)
        current_dynamic = {}
        last_end = {}
        applied_controls = Hash.new { |hash, key| hash[key] = {} }
        missing = []

        timed_events.each do |event|
          part = value(event, :part).to_s
          next if part.empty?

          offset = number_value(event, :offset_ql)
          apply_dynamic_controls(part, offset, dynamic_controls, parts, current_dynamic, applied_controls)
          marks = array_value(event, :local_marks)
          local_dynamic = marks.find { |mark| DYNAMIC_MARKS.include?(mark.to_s) }
          hist[local_dynamic.to_s] += 1 if local_dynamic

          unless truthy?(value(event, :rest))
            entrance = !last_end.key?(part) || offset > last_end.fetch(part) + 0.0001
            if entrance && local_dynamic.nil? && current_dynamic[part].nil?
              missing << {
                "part" => part,
                "offset_label" => value(event, :offset_label).to_s,
                "phrase_id" => value(event, :phrase_id).to_s,
                "pitch_label" => value(event, :pitch_label).to_s
              }
            end
            current_dynamic[part] = local_dynamic.to_s if local_dynamic
            last_end[part] = [last_end[part] || 0.0, number_value(event, :end_offset_ql)].max
          end
        end

        missing
      end

      def apply_dynamic_controls(part, offset, dynamic_controls, parts, current_dynamic, applied_controls)
        dynamic_controls.each_with_index do |control, index|
          next if applied_controls[part][index]
          next unless target_applies?(value(control, :target), part, parts)
          next unless control_offset(control) <= offset + 0.0001

          current_dynamic[part] = value(control, :value).to_s
          applied_controls[part][index] = true
        end
      end

      def target_applies?(target, part, parts)
        return true if target.nil?

        type = value(target, :type).to_s
        return true if type == "all"

        selectors = if type == "list"
                      array_value(target, :selectors)
                    else
                      [value(target, :selector)]
                    end
        part_data = parts.fetch(part, {})
        selectors.compact.map(&:to_s).any? do |selector|
          selector == part ||
            selector == value(part_data, :family).to_s ||
            selector == value(part_data, :notation_group).to_s
        end
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
          "label" => value(event, :offset_label) || value(event, :from_offset_label) || value(event, :at) || value(event, :from),
          "end_label" => value(event, :to_offset_label) || value(event, :to),
          "text" => value(event, :text),
          "bpm" => value(event, :bpm)
        }.compact
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
