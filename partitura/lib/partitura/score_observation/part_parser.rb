# frozen_string_literal: true

module Partitura
  module ScoreObservation
    class PartParser
      STEP_PC = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze

      attr_reader :events, :measures, :meters, :keys, :tempos, :warnings

      def initialize(element, definition)
        @element = element
        @definition = definition
        @part_id = definition.fetch(:id)
        @divisions = 1
        @chromatic = 0
        @octave_change = 0
        @events = []
        @measures = []
        @meters = []
        @keys = []
        @tempos = []
        @warnings = []
      end

      def parse
        @element.xpath("./measure").each.with_index(1) do |measure, index|
          parse_measure(measure, index)
        end
        self
      rescue ArgumentError, KeyError => error
        raise Error.new("invalid_musicxml_value", "#{@part_id}: #{error.message}"), cause: error
      end

      def part
        @definition.merge(
          measure_count: measures.length,
          event_count: events.length,
          pitched_note_count: events.count { |event| event[:kind] == "note" }
        )
      end

      private

      def parse_measure(measure, index)
        state = {
          cursor: 0r,
          furthest: 0r,
          last_note_onset: nil,
          ordinal: 0
        }
        measure.element_children.each do |child|
          parse_measure_child(child, measure, index, state)
        end
        measures << {
          index: index,
          number: measure["number"].to_s,
          implicit: measure["implicit"] == "yes",
          duration_ql: state.fetch(:furthest)
        }
      end

      def parse_measure_child(child, measure, index, state)
        case child.name
        when "attributes" then parse_attributes(child, index)
        when "backup" then move_cursor!(state, -duration(child))
        when "forward" then move_cursor!(state, duration(child))
        when "direction" then parse_tempo(child, index, state.fetch(:cursor))
        when "note" then parse_note(child, measure, index, state)
        end
      end

      def parse_attributes(element, measure_index)
        divisions = text_at(element, "divisions")
        @divisions = positive_integer(divisions, "divisions") if divisions
        parse_transpose(element)
        parse_meter(element, measure_index)
        parse_key(element, measure_index)
      end

      def parse_transpose(element)
        transpose = first_at(element, "transpose")
        return unless transpose

        @chromatic = Integer(text_at(transpose, "chromatic", "0"))
        @octave_change = Integer(text_at(transpose, "octave-change", "0"))
      end

      def parse_meter(element, measure_index)
        each_at(element, "time").each do |time|
          beats = text_at(time, "beats")
          beat_type = text_at(time, "beat-type")
          next unless beats && beat_type

          meters << {
            part_id: @part_id,
            measure_index: measure_index,
            beats: beats,
            beat_type: positive_integer(beat_type, "beat-type"),
            symbol: time["symbol"]
          }.compact
        end
      end

      def parse_key(element, measure_index)
        each_at(element, "key").each do |key|
          fifths = text_at(key, "fifths")
          next unless fifths

          keys << {
            part_id: @part_id,
            measure_index: measure_index,
            fifths: Integer(fifths),
            mode: text_at(key, "mode")
          }.compact
        end
      end

      def parse_tempo(element, measure_index, cursor)
        bpm = first_at(element, "sound")&.[]("tempo")
        bpm ||= text_at(element, "direction-type/metronome/per-minute")
        return unless bpm

        tempos << {
          part_id: @part_id,
          measure_index: measure_index,
          onset_ql: cursor + direction_offset(element),
          bpm: Float(bpm)
        }
      rescue ArgumentError
        warnings << {
          code: "invalid_tempo",
          part_id: @part_id,
          measure_index: measure_index,
          value: bpm.to_s
        }
      end

      def direction_offset(element)
        value = text_at(element, "offset")
        value ? Rational(Integer(value), @divisions) : 0r
      end

      def parse_note(element, measure, measure_index, state)
        chord = !first_at(element, "chord").nil?
        grace = !first_at(element, "grace").nil?
        note_duration = grace ? 0r : duration(element, required: !chord)
        onset = chord ? state.fetch(:last_note_onset) : state.fetch(:cursor)
        raise Error.new("invalid_chord", "#{@part_id} has a chord without a base note") unless onset

        state[:ordinal] += 1
        events << note_event(
          element,
          measure: measure,
          measure_index: measure_index,
          ordinal: state.fetch(:ordinal),
          onset: onset,
          note_duration: note_duration,
          chord: chord,
          grace: grace
        )
        state[:last_note_onset] = onset
        state[:cursor] += note_duration unless chord || grace
        state[:furthest] = [state.fetch(:furthest), onset + note_duration, state.fetch(:cursor)].max
      end

      def note_event(element, measure:, measure_index:, ordinal:, onset:, note_duration:, chord:, grace:)
        event = {
          event_id: "event:#{@part_id}:#{measure_index}:#{ordinal}",
          part_id: @part_id,
          measure_index: measure_index,
          measure_number: measure["number"].to_s,
          measure_onset_ql: onset,
          duration_ql: note_duration,
          kind: note_kind(element),
          voice: text_at(element, "voice", "1"),
          staff: positive_integer(text_at(element, "staff", "1"), "staff"),
          chord: chord,
          grace: grace,
          cue: !first_at(element, "cue").nil?,
          ties: each_at(element, "tie").filter_map { |tie| tie["type"] }.uniq.sort
        }
        event.merge!(pitch_data(element))
        instrument_id = first_at(element, "instrument")&.[]("id")
        event[:instrument_id] = instrument_id if instrument_id
        event
      end

      def note_kind(element)
        return "rest" if first_at(element, "rest")
        return "unpitched" if first_at(element, "unpitched")
        return "note" if first_at(element, "pitch")

        raise Error.new("missing_pitch", "#{@part_id} has a note without pitch, unpitched, or rest")
      end

      def pitch_data(element)
        pitch = first_at(element, "pitch")
        return pitched_data(pitch) if pitch

        unpitched = first_at(element, "unpitched")
        return unpitched_data(unpitched) if unpitched

        {}
      end

      def pitched_data(pitch)
        written = midi(
          text_at(pitch, "step"),
          Integer(text_at(pitch, "alter", "0")),
          Integer(text_at(pitch, "octave"))
        )
        sounding = written + @chromatic + (12 * @octave_change)
        validate_midi!(sounding)
        { written_midi: written, midi: sounding }
      end

      def unpitched_data(unpitched)
        display = midi(
          text_at(unpitched, "display-step"),
          0,
          Integer(text_at(unpitched, "display-octave"))
        )
        { display_midi: display }
      end

      def midi(step, alter, octave)
        ((octave + 1) * 12) + STEP_PC.fetch(step) + alter
      end

      def validate_midi!(value)
        return if (0..127).cover?(value)

        raise Error.new("invalid_pitch", "#{@part_id} has out-of-range sounding MIDI pitch #{value}")
      end

      def move_cursor!(state, delta)
        state[:cursor] += delta
        if state.fetch(:cursor).negative?
          raise Error.new("invalid_cursor", "#{@part_id} has a backup before the measure start")
        end
        state[:furthest] = [state.fetch(:furthest), state.fetch(:cursor)].max
        state[:last_note_onset] = nil
      end

      def duration(element, required: true)
        value = text_at(element, "duration")
        if value.nil?
          raise Error.new("missing_duration", "#{@part_id} has an event without duration") if required

          return 0r
        end
        Rational(Integer(value), @divisions)
      end

      def positive_integer(value, label)
        number = Integer(value)
        raise ArgumentError, "#{label} must be positive" unless number.positive?

        number
      end

      def first_at(element, path)
        element.at_xpath(path)
      end

      def each_at(element, path)
        element.xpath(path)
      end

      def text_at(element, path, default = nil)
        text = first_at(element, path)&.text
        text.nil? ? default : text
      end
    end
  end
end
