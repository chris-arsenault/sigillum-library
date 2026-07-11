# frozen_string_literal: true

module Partitura
  module Export
    module MIDI
      module Tracks
        private

        def tempo_track
          build_track(tempo_track_events.sort_by(&:first))
        end

        def tempo_track_events
          events = Array(@data["tempo_events"]).filter_map { |event| tempo_meta_event(event) }
          events.concat(meter_meta_events)
          events.concat(key_meta_events)
          events
        end

        def meter_meta_events
          timeline = Array(@data["meter_events"])
          timeline = [{ "meter" => @data["meter"], "offset_ql" => 0 }] if timeline.empty?
          timeline.map do |event|
            [ticks(rational(event.fetch("offset_ql", 0))), meta_event(0x58, time_signature_bytes(event.fetch("meter")))]
          end
        end

        def key_meta_events
          timeline = [{ "key" => @data["key"] || "C", "offset_ql" => 0 }] + Array(@data["key_changes"])
          timeline.map do |event|
            [ticks(rational(event.fetch("offset_ql", 0))), meta_event(0x59, key_signature_bytes(event.fetch("key")))]
          end
        end

        def tempo_meta_event(event)
          return nil unless tempo_mark_event?(event)

          micros = tempo_microseconds(event.fetch("bpm"))
          [ticks(rational(event["offset_ql"] || 0)), meta_event(0x51, [micros].pack("N").bytes.last(3).pack("C*"))]
        end

        def tempo_microseconds(bpm)
          value = rational(bpm)
          micros = value.positive? ? (Rational(60_000_000) / value).round : 0
          return micros if Production::MIDI_TEMPO_MICROSECONDS.cover?(micros)

          raise Error, "tempo #{bpm.inspect} is outside the MIDI playback range"
        end

        def tempo_mark_event?(event)
          (event["kind"].nil? || event["kind"] == "mark") && event["bpm"]
        end

        def part_track(part, index)
          channel = midi_channel(part, index)
          events = part_track_header(part, channel)
          velocity = 72
          timed_events_for(part.fetch("id")).each do |event|
            velocity = event_velocity(event, velocity)
            events.concat(part_note_events(event, channel, velocity, part)) unless event["rest"]
          end
          build_track(events.sort_by { |tick, bytes| part_track_sort_key(tick, bytes, channel) })
        end

        def notes_track
          build_track([[0, meta_event(0x03, "Notes")]])
        end

        def midi_channel(part, index)
          return 9 if percussion_part?(part)

          pitched_ordinal = parts.first(index).count { |candidate| !percussion_part?(candidate) }
          channel = pitched_ordinal % 15
          channel >= 9 ? channel + 1 : channel
        end

        def percussion_part?(part)
          part["family"].to_s == "percussion"
        end

        def part_track_header(part, channel)
          [
            [0, meta_event(0x03, part.fetch("name").to_s)],
            [0, [0xC0 | channel, PROGRAMS.fetch(part["music21_instrument"], 0)].pack("C*")]
          ]
        end

        def event_velocity(event, current)
          local_dynamic = Array(event["local_marks"]).find { |mark| DYNAMIC_VELOCITY.key?(mark) }
          local_dynamic ? DYNAMIC_VELOCITY.fetch(local_dynamic) : current
        end

        def part_note_events(event, channel, velocity, part)
          start_tick = ticks(rational(event.fetch("offset_ql")))
          end_tick = ticks(rational(event.fetch("offset_ql")) + rational(event.fetch("duration_ql")))
          event_pitches(event).flat_map do |pitch|
            midi = midi_pitch_for_part(part, pitch)
            [
              [start_tick, [0x90 | channel, midi, velocity].pack("C*")],
              [end_tick, [0x80 | channel, midi, 0].pack("C*")]
            ]
          end
        end

        def midi_pitch_for_part(part, pitch)
          entry = Array(part["percussion_map"]).find { |candidate| candidate.fetch("source_pitch") == pitch.to_s }
          entry ? Integer(entry.fetch("midi_note")) : midi_pitch(pitch)
        end

        def part_track_sort_key(tick, bytes, channel)
          [tick, bytes.getbyte(0) == (0x90 | channel) ? 1 : 0]
        end

        def build_track(absolute_events)
          body = +"".b
          last_tick = 0
          absolute_events.each do |tick, bytes|
            body << variable_length(tick - last_tick)
            body << bytes
            last_tick = tick
          end
          body << variable_length(0)
          body << meta_event(0x2F, "")
          "MTrk".b + [body.bytesize].pack("N") + body
        end

        def meta_event(type, data)
          data = data.b
          [0xFF, type].pack("C*") + variable_length(data.bytesize) + data
        end

        def variable_length(value)
          value = Integer(value)
          buffer = value & 0x7F
          while (value >>= 7).positive?
            buffer <<= 8
            buffer |= ((value & 0x7F) | 0x80)
          end

          variable_length_bytes(buffer)
        end

        def variable_length_bytes(buffer)
          bytes = +"".b
          loop do
            bytes << (buffer & 0xFF)
            break if (buffer & 0x80).zero?

            buffer >>= 8
          end
          bytes
        end

        def timed_events_for(part_id)
          Array(@data["timed_events"]).select { |event| event["part"] == part_id }.sort_by do |event|
            [rational(event.fetch("offset_ql")), rational(event.fetch("duration_ql"))]
          end.then { |events| coalesce_authored_ties(events) }
        end

        # Authored ties (`tie(` / `tie)`) split one sustained note into tied
        # noteheads for notation. MIDI must play them as a single held note, so
        # tie chains are merged back into the head event's duration.
        def coalesce_authored_ties(events)
          consumed = {}
          events.each_with_index.filter_map do |event, index|
            next if consumed[index]
            next event unless authored_tie_start?(event)

            coalesce_tie_chain(events, index, consumed)
          end
        end

        def coalesce_tie_chain(events, index, consumed)
          head = events[index]
          total = rational(head.fetch("duration_ql"))
          current = head
          cursor = index
          while authored_tie_start?(current)
            cursor = tie_continuation_index(events, cursor, current)
            break unless cursor

            consumed[cursor] = true
            current = events[cursor]
            total += rational(current.fetch("duration_ql"))
          end
          head.merge("duration_ql" => total)
        end

        def tie_continuation_index(events, index, current)
          end_offset = rational(current.fetch("offset_ql")) + rational(current.fetch("duration_ql"))
          pitches = event_pitches(current)
          ((index + 1)...events.length).find do |candidate|
            continuation_matches?(events[candidate], pitches, end_offset)
          end
        end

        def continuation_matches?(event, pitches, end_offset)
          tie_close?(event) && event_pitches(event) == pitches &&
            rational(event.fetch("offset_ql")) == end_offset
        end

        def authored_tie_start?(event)
          Array(event["local_marks"]).include?("tie(")
        end

        def tie_close?(event)
          Array(event["local_marks"]).include?("tie)")
        end

        def event_pitches(event)
          Array(event["pitches"]).compact
        end
      end
    end
  end
end
