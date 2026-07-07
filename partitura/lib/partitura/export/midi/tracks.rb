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
          events << [0, meta_event(0x58, time_signature_bytes(@data["meter"]))]
          events << [0, meta_event(0x59, key_signature_bytes(@data["key"] || "C"))]
        end

        def tempo_meta_event(event)
          return nil unless tempo_mark_event?(event)

          micros = (60_000_000 / Float(event["bpm"])).round
          [ticks(rational(event["offset_ql"] || 0)), meta_event(0x51, [micros].pack("N").bytes.last(3).pack("C*"))]
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
            events.concat(part_note_events(event, channel, velocity)) unless event["rest"]
          end
          build_track(events.sort_by { |tick, bytes| part_track_sort_key(tick, bytes, channel) })
        end

        def notes_track
          build_track([[0, meta_event(0x03, "Notes")]])
        end

        def midi_channel(part, index)
          part["family"].to_s == "percussion" ? 9 : index % 16
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

        def part_note_events(event, channel, velocity)
          start_tick = ticks(rational(event.fetch("offset_ql")))
          end_tick = ticks(rational(event.fetch("offset_ql")) + rational(event.fetch("duration_ql")))
          event_pitches(event).flat_map do |pitch|
            midi = midi_pitch(pitch)
            [
              [start_tick, [0x90 | channel, midi, velocity].pack("C*")],
              [end_tick, [0x80 | channel, midi, 0].pack("C*")]
            ]
          end
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
          end
        end

        def event_pitches(event)
          Array(event["pitches"]).compact
        end
      end
    end
  end
end
