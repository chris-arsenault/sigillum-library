# frozen_string_literal: true

module Partitura
  module Production
    # Zero-diff verification of staff_bar checkpoint lanes against the compiled
    # timeline. A checkpoint is an assertion, not decoration: every lane of the form
    # "part_id: tokens" is re-derived from the sounding events and any divergence is a
    # compile error naming the bar, lane, and first divergent slot.
    #
    # Lane grammar: tokens divide the bar into equal slots. `_` sustains, `.` is
    # silence, `X` is an unpitched attack, `C5` is a pitched attack, `Bb4/A4` is two
    # attacks inside one slot in order. Enharmonic spelling is compared by midi.
    module CheckpointValidation
      STAFF_GRID_DOCS = ["docs/architecture/partitura/surfaces/staff_grid.md"].freeze

      Slot = Struct.new(:staff_bar, :lane, :part_id, :index, :start, :duration, :attacks, :part_events,
                        keyword_init: true) do
        def sounding_at_start?
          part_events.any? { |event| event.offset < start && event.offset + event.duration > start }
        end

        def overlapped?
          part_events.any? { |event| event.offset < start + duration && event.offset + event.duration > start }
        end

        def attack_labels
          attacks.map(&:pitch_label).join("/")
        end
      end

      private

      def validate_staff_bars!(events)
        sounding_by_part = Production.merge_authored_ties(events.reject(&:rest?)).group_by(&:part)
        staff_bars.each do |staff_bar|
          staff_bar.lanes.each do |lane|
            validate_checkpoint_lane!(staff_bar, lane, sounding_by_part)
          end
        end
      end

      def validate_checkpoint_lane!(staff_bar, lane, sounding_by_part)
        part_id, tokens = parse_checkpoint_lane(staff_bar, lane)
        bar_start = offset_for(staff_bar.number, 1)
        duration = Rational(bar_length_for(staff_bar.number), tokens.length)
        base = Slot.new(staff_bar: staff_bar, lane: lane, part_id: part_id, duration: duration,
                        part_events: sounding_by_part.fetch(part_id, []))
        tokens.each_with_index do |token, index|
          verify_checkpoint_slot!(fill_slot(base, index, bar_start + (duration * index)), token)
        end
      end

      def fill_slot(base, index, start)
        slot = base.dup
        slot.index = index
        slot.start = start
        slot.attacks = slot.part_events.select { |event| event.offset >= start && event.offset < start + slot.duration }
                           .sort_by(&:offset)
        slot
      end

      def parse_checkpoint_lane(staff_bar, lane)
        unless lane.part && @parts.key?(lane.part)
          raise checkpoint_error(
            staff_bar, lane,
            code: "checkpoint_lane_unparseable",
            detail: "must be \"<roster_part_id>: tokens\" (got part #{lane.part.inspect})",
            repair: "Write the lane as a roster part id, a colon, then one token per slot: pitch, `Bb4/A4`, " \
                    "`_` (sustain), `.` (silence), or `X` (unpitched attack)."
          )
        end

        raise checkpoint_error(staff_bar, lane, code: "checkpoint_lane_unparseable",
                                                detail: "has no slot tokens",
                                                repair: "Add one token per slot after the part id.") if
          lane.tokens.empty?

        [lane.part, lane.tokens]
      end

      def verify_checkpoint_slot!(slot, token)
        case token
        when "_" then verify_sustain_slot!(slot)
        when "." then verify_silent_slot!(slot)
        when "X", "x" then verify_unpitched_attack_slot!(slot)
        else verify_pitched_slot!(slot, token)
        end
      end

      def verify_sustain_slot!(slot)
        raise checkpoint_mismatch(slot, expected: "sustain (_)", found: "attack of #{slot.attack_labels}") if
          slot.attacks.any?
        return if slot.sounding_at_start?

        raise checkpoint_mismatch(slot, expected: "sustain (_)", found: "silence")
      end

      def verify_silent_slot!(slot)
        raise checkpoint_mismatch(slot, expected: "silence (.)", found: "attack of #{slot.attack_labels}") if
          slot.attacks.any?
        return unless slot.overlapped?

        raise checkpoint_mismatch(slot, expected: "silence (.)", found: "a sustained note")
      end

      def verify_unpitched_attack_slot!(slot)
        return if slot.attacks.any?

        raise checkpoint_mismatch(slot, expected: "an attack (X)", found: "no attack")
      end

      def verify_pitched_slot!(slot, token)
        expected = checkpoint_token_midis(slot, token)
        found = slot.attacks.map { |event| event.pitches.map { |pitch| Production.pitch_to_midi(pitch) } }
        return if found.flatten == expected || found.map(&:min) == expected

        raise checkpoint_mismatch(slot, expected: "attack(s) #{token}",
                                        found: slot.attacks.empty? ? "no attack" : slot.attack_labels)
      end

      def checkpoint_token_midis(slot, token)
        token.split("/").map { |pitch| Production.pitch_to_midi(pitch) }
      rescue CompileError
        raise checkpoint_error(
          slot.staff_bar, slot.lane,
          code: "checkpoint_lane_unparseable",
          detail: "token #{token.inspect} is not a pitch, `_`, `.`, `X`, or `A4/B4` group",
          repair: "Use one token per slot: pitch, `Bb4/A4`, `_`, `.`, or `X`."
        )
      end

      def checkpoint_mismatch(slot, expected:, found:)
        compile_error(
          code: "checkpoint_mismatch",
          message: "staff_bar #{slot.staff_bar.number} lane #{slot.lane.role} (#{slot.part_id}) slot " \
                   "#{slot.index + 1} expects #{expected}; the timeline has #{found}.",
          repair_instruction: "Checkpoints are verified against the sounding result: fix the lane to match the " \
                              "music, or fix the phrases/placements so the asserted checkpoint is true.",
          help_topic: "staff_grid",
          docs: STAFF_GRID_DOCS,
          extra: { bar: slot.staff_bar.number, lane: slot.lane.role, part: slot.part_id, slot: slot.index + 1 }
        )
      end

      def checkpoint_error(staff_bar, lane, code:, detail:, repair:)
        compile_error(
          code: code,
          message: "staff_bar #{staff_bar.number} lane #{lane.role} #{detail}.",
          repair_instruction: repair,
          help_topic: "staff_grid",
          docs: STAFF_GRID_DOCS,
          extra: { bar: staff_bar.number, lane: lane.role }
        )
      end
    end
  end
end
