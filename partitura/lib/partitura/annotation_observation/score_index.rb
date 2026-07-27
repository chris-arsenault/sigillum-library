# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    class ScoreIndex
      include ScoreFeatures

      attr_reader :observation_digest

      def initialize(observation)
        @observation_digest = observation.fetch("observation_digest")
        score = observation.fetch("score")
        @parts = score.fetch("parts")
        @measures = score.fetch("measures")
        @meter_events = score.fetch("meter_events")
        @duration = rational(observation.fetch("summary").fetch("duration_ql"))
        @part_by_id = @parts.to_h { |part| [part.fetch("id"), part] }
        build_event_indexes(score.fetch("timed_events"))
        @feature_cache = {}
        @scope_cache = {}
      end

      def duration
        @duration
      end

      def measure_offsets
        @measures.map { |measure| rational(measure.fetch("offset_ql")) }
      end

      def meter_events
        @meter_events.map do |event|
          {
            measure_index: event.fetch("measure_index"),
            beats: event.fetch("beats").to_s,
            beat_type: event.fetch("beat_type")
          }
        end
      end

      def part_by_index(index)
        part = @parts[index]
        raise Error.new("unknown_annotation_part", "part index is out of range: #{index}") unless part

        { part_id: part.fetch("id"), staff: nil, label: normalized_part_label(part) }
      end

      def resolve_part(name, start_q: nil, end_q: nil)
        resolution = resolve_divided_part(name, start_q, end_q)
        return resolution if resolution

        query = normalize(name)
        exact = @parts.select { |part| matching_aliases(part).include?(canonical_instrument_alias(query)) }
        resolution = resolve_candidates(exact.map { |part| resolved(part) }, start_q, end_q)
        return resolution if resolution

        resolution = resolve_combined_part(query, start_q, end_q)
        return resolution if resolution

        raise Error.new("unknown_annotation_part", "cannot bind annotation part: #{name.inspect}")
      end

      def measure_offset(reference, fraction:)
        key = reference.to_s.strip
        measure = @measures.find { |item| item.fetch("number").to_s == key }
        measure ||= @measures[Integer(key) - 1]
        raise Error.new("unknown_annotation_measure", "cannot bind measure: #{reference}") unless measure

        offset = rational(measure.fetch("offset_ql"))
        duration = rational(measure.fetch("duration_ql"))
        offset + (duration * rational(fraction))
      end

      def scope(start_q, end_q, part_id: nil, staff: nil)
        start_value, end_value = validate_span(start_q, end_q)
        key = [start_value, end_value, part_id, staff]
        cached = @scope_cache[key]
        return cached.dup if cached

        events = events_in(start_value, end_value, part_id:, staff:)
        payload = {
          start_ql: start_value,
          end_ql: end_value,
          start_measure_index: measure_at(start_value),
          end_measure_index: measure_at([end_value, @duration].min, ending: true),
          event_count: events.length
        }
        payload[:part_id] = part_id if part_id
        payload[:staff] = staff if staff
        payload[:first_event_id] = events.first.fetch("event_id") if events.first
        payload[:last_event_id] = events.last.fetch("event_id") if events.last
        @scope_cache[key] = payload.freeze
        payload.dup
      end

      def events_at(offset, part_id:, staff: nil)
        point = rational(offset)
        collection = event_collection(part_id, staff)
        event_slice(collection, point, point + Rational(1, 1_000_000))
          .select { |event| rational(event.fetch("onset_ql")) == point }
      end

      def note_events_near(offset, part_id:, staff: nil, tolerance: Rational(1, 1000))
        point = rational(offset)
        collection = event_collection(part_id, staff)
        candidates = event_slice(collection, point - tolerance, point + tolerance)
                     .select { |event| event.fetch("kind") == "note" }
        return [] if candidates.empty?

        distance = candidates.map { |event| (rational(event.fetch("onset_ql")) - point).abs }.min
        candidates.select do |event|
          (rational(event.fetch("onset_ql")) - point).abs == distance
        end
      end

      private

      def events_in(start_q, end_q, part_id: nil, staff: nil)
        event_slice(event_collection(part_id, staff), start_q, end_q)
      end

      def build_event_indexes(events)
        @event_index = []
        @events_by_part = Hash.new { |mapping, key| mapping[key] = [] }
        @events_by_part_staff = Hash.new { |mapping, key| mapping[key] = [] }
        events.each do |event|
          indexed = [rational(event.fetch("onset_ql")), event]
          @event_index << indexed
          part_id = event.fetch("part_id")
          @events_by_part[part_id] << indexed
          @events_by_part_staff[[part_id, event.fetch("staff")]] << indexed
        end
        @event_index.sort_by!(&:first)
        @events_by_part.each_value { |items| items.sort_by!(&:first) }
        @events_by_part_staff.each_value { |items| items.sort_by!(&:first) }
      end

      def event_collection(part_id, staff)
        return @event_index unless part_id
        return @events_by_part.fetch(part_id, []) unless staff

        @events_by_part_staff.fetch([part_id, staff], [])
      end

      def event_slice(collection, start_q, end_q)
        index = collection.bsearch_index { |onset, _| onset >= start_q } || collection.length
        events = []
        while index < collection.length && collection[index].first < end_q
          events << collection[index].last
          index += 1
        end
        events
      end

      def validate_span(start_q, end_q)
        start_value = rational(start_q)
        end_value = rational(end_q)
        unless start_value >= 0r && end_value > start_value && end_value <= @duration
          raise Error.new(
            "annotation_span_out_of_range",
            "annotation span #{start_value}-#{end_value} is outside 0-#{@duration}"
          )
        end
        [start_value, end_value]
      end

      def measure_at(offset, ending: false)
        point = ending && offset == @duration ? offset - Rational(1, 1_000_000) : offset
        measure = @measures.reverse.find { |item| rational(item.fetch("offset_ql")) <= point }
        measure&.fetch("index")
      end

      def resolve_combined_part(query, start_q, end_q)
        match = canonical_instrument_alias(query).match(/\A([a-z]+)(\d+)\z/)
        return unless match

        base = match[1]
        number = match[2]
        candidates = @parts.filter_map { |part| combined_candidate(part, base, number) }
        resolution = resolve_candidates(candidates, start_q, end_q)
        return resolution if resolution

        resolve_collapsed_part(base, number)
      end

      def resolve_collapsed_part(base, number)
        collapsed = @parts.select { |part| matching_aliases(part).include?(base) }
        return unless collapsed.length == 1

        resolved(collapsed.first).merge(
          collapsed_numbered_part: true,
          annotation_part_number: Integer(number)
        )
      end

      def resolve_divided_part(name, start_q, end_q)
        match = name.to_s.downcase.strip.match(/\A([a-z]+)(\d+)-(\d+)\z/)
        return unless match

        section_number = Integer(match[2])
        return unless section_number.between?(1, 26)

        section = (96 + section_number).chr
        query = "#{match[1]}#{section}#{match[3]}"
        candidates = @parts.select { |part| matching_aliases(part).include?(query) }
        resolve_candidates(candidates.map { |part| resolved(part) }, start_q, end_q)
      end

      def resolve_candidates(candidates, start_q, end_q)
        return candidates.first if candidates.length == 1
        return unless candidates.any? && start_q && end_q

        choose_active_candidate(candidates, start_q, end_q)
      end

      def choose_active_candidate(candidates, start_q, end_q)
        ranked = candidates.map do |candidate|
          count = events_in(
            rational(start_q),
            rational(end_q),
            part_id: candidate.fetch(:part_id),
            staff: candidate[:staff]
          ).count { |event| event["midi"] }
          [count, candidate]
        end
        maximum = ranked.map(&:first).max
        winners = ranked.select { |count, _| count == maximum }.map(&:last)
        winners.min_by { |candidate| [candidate.fetch(:part_id), candidate[:staff].to_i] }
               .merge(candidate_count: candidates.length, tied_candidate_count: winners.length)
      end

      def combined_candidate(part, base, number)
        pattern = /\A#{Regexp.escape(base)}(\d{2,})\z/
        alias_match = matching_aliases(part).filter_map do |name|
          combined = name.match(pattern)
          combined if combined && combined[1].include?(number)
        end.first
        return unless alias_match

        resolved(part, staff: alias_match[1].chars.index(number) + 1)
      end

      def resolved(part, staff: nil)
        { part_id: part.fetch("id"), staff:, label: normalized_part_label(part) }
      end

      def normalized_part_label(part)
        normalize(part.fetch("name"))
      end

      def part_aliases(part)
        [
          part["name"],
          part["abbreviation"],
          *part.fetch("instruments", []).map { |instrument| instrument["name"] }
        ].compact.map { |value| normalize(value) }.uniq
      end

      def matching_aliases(part)
        part_aliases(part).map { |name| canonical_instrument_alias(name) }
      end

      def canonical_instrument_alias(value)
        value.sub(/\Ahn(?=\d|\z)/, "horn")
             .sub(/\Atbn(?=\d|\z)/, "trombone")
      end

      def normalize(value)
        value.to_s.downcase.gsub(/[^a-z0-9]/, "")
      end

      def rational(value)
        Rational(value.to_s)
      end

    end
  end
end
