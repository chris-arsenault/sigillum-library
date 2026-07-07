# frozen_string_literal: true

module Partitura
  module Production
    module Validation
      private

      def validate_meter_events!
        seen = {}
        @meter_changes.each do |event|
          Production.meter_to_bar_length(event.meter)
          validate_unique_meter_bar!(seen, event)
          seen[event.bar] = true
        end
      end

      def validate_unique_meter_bar!(seen, event)
        return unless seen.key?(event.bar)

        raise compile_error(
          code: "duplicate_meter_change",
          message: "More than one meter change is declared at bar #{event.bar}.",
          repair_instruction: "Keep at most one meter event per bar.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end

      def validate_spans_and_placements!(phrase_map)
        @sections.each do |section|
          section.spans.each { |span| validate_span!(section, span, phrase_map) }
        end
      end

      def validate_span!(section, span, phrase_map)
        validate_span_inside_section!(section, span)
        span.placements.each do |placement|
          validate_placement_inside_span!(span, placement)
          validate_placement_alignment!(span, placement, phrase_map)
        end
      end

      def validate_span_inside_section!(section, span)
        return if section.bars.cover?(span.bars.begin) && section.bars.cover?(span.bars.end)

        raise compile_error(
          code: "span_outside_section",
          message: span_outside_section_message(section, span),
          repair_instruction: "Keep span bars inside the containing section.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end

      def span_outside_section_message(section, span)
        "Span bars #{span.bars.begin}-#{span.bars.end} are outside section #{section.id} " \
          "bars #{section.bars.begin}-#{section.bars.end}."
      end

      def validate_placement_inside_span!(span, placement)
        return if span.bars.cover?(placement.bar)

        raise compile_error(
          code: "placement_outside_span",
          message: placement_outside_span_message(span, placement),
          repair_instruction: "Move the placement into the containing span or place it in a span that covers that " \
                              "bar.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end

      def placement_outside_span_message(span, placement)
        "Placement #{placement.phrase_id} at bar #{placement.bar} is outside span bars " \
          "#{span.bars.begin}-#{span.bars.end}."
      end

      # Time-alignment requirements for placed phrase material:
      # 1. every `|` bar marker must land exactly on a barline,
      # 2. sounding onsets inside one segment must stay in one bar (a stream spanning
      #    several bars of attacks needs a `|` at each barline),
      # 3. placed material must not sound past the end of its containing span.
      def validate_placement_alignment!(span, placement, phrase_map)
        phrase = phrase_map[placement.phrase_id]
        return unless phrase

        end_offset = validate_placement_segments!(placement, phrase)
        validate_span_overflow!(span, placement, phrase, end_offset)
      end

      def validate_placement_segments!(placement, phrase)
        offset = offset_for(placement.bar, placement.beat)
        boundaries = segment_boundaries(phrase)
        onset_bar = nil
        phrase.events.each_with_index do |event, index|
          if boundaries.include?(index) && index.positive?
            validate_marker_on_barline!(placement, phrase, offset, boundaries.index(index))
            onset_bar = nil
          end
          onset_bar = validate_onset_containment!(placement, phrase, event, offset, onset_bar)
          offset += event.duration
        end
        offset
      end

      def segment_boundaries(phrase)
        counts = phrase.segment_counts
        return [] if counts.nil? || counts.length < 2

        boundaries = []
        total = 0
        counts.each do |count|
          total += count
          boundaries << total
        end
        boundaries[0...-1].reject(&:zero?)
      end

      def validate_marker_on_barline!(placement, phrase, offset, marker_index)
        bar, bar_start = bar_containing(offset)
        return if bar_start == offset

        raise compile_error(
          code: "bar_marker_misaligned",
          message: "Phrase #{phrase.id} placed at #{placement_location(placement)}: " \
                   "bar marker #{marker_index + 1} lands at #{format_offset(offset)}, not on a barline.",
          repair_instruction: "Adjust the durations so the segment before this `|` ends exactly at the barline " \
                              "(watch the meter and any pickup offset), or move the `|`.",
          help_topic: phrase.surface.to_s,
          docs: ["docs/architecture/partitura/surfaces/#{phrase.surface}.md"],
          extra: { phrase: phrase.id, part: placement.part, bar: bar }
        )
      end

      def validate_onset_containment!(placement, phrase, event, offset, onset_bar)
        return onset_bar if event.rest?

        bar, = bar_containing(offset)
        if onset_bar && bar != onset_bar
          raise compile_error(
            code: "bar_onsets_cross_barline",
            message: "Phrase #{phrase.id} placed at #{placement_location(placement)}: one `|` segment " \
                     "has attacks in bar #{onset_bar} and bar #{bar}.",
            repair_instruction: "Add a `|` at each barline so every segment holds one bar of attacks. Only a " \
                                "sustained event may cross a barline without a marker.",
            help_topic: phrase.surface.to_s,
            docs: ["docs/architecture/partitura/surfaces/#{phrase.surface}.md"],
            extra: { phrase: phrase.id, part: placement.part, bar: bar }
          )
        end
        bar
      end

      def validate_span_overflow!(span, placement, phrase, end_offset)
        span_end = offset_for(span.bars.end + 1, 1)
        return if end_offset <= span_end

        raise compile_error(
          code: "phrase_exceeds_span",
          message: "Phrase #{phrase.id} placed at #{placement_location(placement)} sounds until " \
                   "#{format_offset(end_offset)}, past the end of span bars #{span.bars.begin}-#{span.bars.end}.",
          repair_instruction: "Shorten the phrase, move the placement earlier, or extend the span/section bars " \
                              "to cover the sounding material.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"],
          extra: { phrase: phrase.id, part: placement.part }
        )
      end

      def placement_location(placement)
        "bar #{placement.bar} beat #{Production.format_duration(placement.beat)}"
      end

      def bar_containing(offset)
        bar = 1
        bar_start = Rational(0)
        loop do
          length = bar_length_for(bar)
          break if offset < bar_start + length

          bar_start += length
          bar += 1
        end
        [bar, bar_start]
      end

      # A declared roster range is a contract: every placed note for that part must sit
      # inside it. Parts without range: opt out of enforcement.
      def validate_part_ranges!(events)
        ranges = declared_part_ranges
        events.each do |event|
          range = ranges[event.part]
          next if range.nil? || event.rest?

          event.pitches.each { |pitch| validate_pitch_in_range!(event, pitch, range) }
        end
      end

      def declared_part_ranges
        @parts.each_value.with_object({}) do |part, out|
          out[part.id] = Production.parse_part_range(part.range, part: part.id) if part.range
        end
      end

      def validate_pitch_in_range!(event, pitch, range)
        midi = Production.pitch_to_midi(pitch)
        return if midi.between?(range[0], range[1])

        part = @parts.fetch(event.part)
        raise compile_error(
          code: "note_out_of_range",
          message: "#{pitch} at #{format_offset(event.offset)} (phrase #{event.phrase_id}, part #{part.id}) is " \
                   "outside the declared range #{part.range}.",
          repair_instruction: "Move the note inside the range, assign the material to a part that covers it, or " \
                              "correct the roster range: declaration.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"],
          extra: { part: part.id, phrase: event.phrase_id, declared_range: part.range }
        )
      end

      def validate_tempo_events!
        @tempo_events.each { |event| validate_ranged_reference!(event) }
      end

      def validate_key_changes!
        @key_changes.each { |key_change| offset_for_reference(key_change.at) }
      end

      # A degrees phrase that silently inherited the piece-level key must still be in
      # that key where it is placed. If a key_change moved the tonality, the source has
      # to say so explicitly (span/section `key`, or phrase `key_context`).
      def validate_degree_key_assumptions!(phrase_map)
        return if @key_changes.empty?

        placements.each do |placement|
          phrase = phrase_map[placement.phrase_id]
          next unless phrase&.assumed_key

          active = key_for_bar(placement.bar)
          next if same_key?(phrase.assumed_key, active)

          raise compile_error(
            code: "key_context_required",
            message: "Phrase #{phrase.id} inherited key #{phrase.assumed_key.inspect} but a key_change makes " \
                     "#{active.inspect} active at bar #{placement.bar}.",
            repair_instruction: "Declare the key explicitly where the phrase lives: `key \"#{active}\"` on the " \
                                "span/section, or `key_context` on the phrase.",
            help_topic: "degrees",
            docs: ["docs/architecture/partitura/surfaces/degrees.md"],
            extra: { phrase: phrase.id, bar: placement.bar, active_key: active }
          )
        end
      end

      def same_key?(left, right)
        normalize_key(left) == normalize_key(right)
      end

      def normalize_key(value)
        parsed = Production.parse_key_context(value)
        [parsed.fetch(:tonic_midi) % 12, parsed.fetch(:steps)]
      rescue CompileError
        value.to_s
      end

      def validate_controls!(events)
        @controls.each do |control|
          validate_ranged_reference!(control)
          validate_control_target!(control, events)
        end
      end

      def validate_ranged_reference!(event)
        if event.at
          offset_for_reference(event.at)
        else
          offset_for_reference(event.from)
          offset_for_reference(event.to)
        end
      end

      def validate_control_target!(control, events)
        unmatched = unmatched_control_selectors(control.target, events)
        return if unmatched.empty?

        raise compile_error(
          code: "unknown_control_target",
          message: "Control target #{unmatched.join(', ')} does not match any part, family, or role.",
          repair_instruction: "Use an existing part id, family, role, :all, or a list of those selectors.",
          help_topic: "controls",
          docs: ["docs/architecture/partitura/surfaces/controls.md"]
        )
      end

      def unmatched_control_selectors(target, events)
        return @parts.empty? ? ["all"] : [] if target == :all || target.to_s == "all"

        target_selectors(target).select { |selector| parts_matching_selector(selector, events).empty? }.map(&:to_s)
      end

      def target_selectors(target)
        target.is_a?(Array) ? target : [target]
      end

      def parts_matching_selector(selector, events)
        selector_text = selector.to_s
        direct_matches = direct_part_matches(selector_text)
        return direct_matches unless direct_matches.empty?

        role_part_matches(selector_text, events)
      end

      def direct_part_matches(selector_text)
        @parts.values.filter_map do |part|
          part.id if part_selector_values(part).include?(selector_text)
        end
      end

      def part_selector_values(part)
        [part.id, part.family, part.name].compact.map(&:to_s)
      end

      def role_part_matches(selector_text, events)
        events.filter_map do |event|
          event.part if event.role.to_s == selector_text && @parts.key?(event.part)
        end
      end
    end
  end
end
