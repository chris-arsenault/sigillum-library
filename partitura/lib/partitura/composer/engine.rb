# frozen_string_literal: true

require_relative "../production"
require_relative "score"

module Partitura
  module Composer
    class Engine
      EXPRESSIVE = {
        "dynamic" => ->(builder, value, options) { builder.dynamic(value, **options) },
        "swing" => ->(builder, value, options) { builder.swing(value, **options) },
        "crescendo" => ->(builder, _value, options) { builder.crescendo(**options) },
        "diminuendo" => ->(builder, _value, options) { builder.diminuendo(**options) },
        "pedal" => ->(builder, value, options) { builder.pedal(value, **options) },
        "text" => ->(builder, value, options) { builder.text(value, **options) },
        "intentional_dissonance" => ->(builder, value, options) { builder.intentional_dissonance(value, **options) },
        "clef" => ->(builder, value, options) { builder.clef(value, **options) },
        "chord" => ->(builder, value, options) { builder.chord(value, **options) },
        "key" => ->(builder, value, options) { builder.key_change(value, **options) },
        "key_signature" => ->(builder, value, options) { builder.key_signature(value, **options) },
        "harp_pedals" => ->(builder, value, options) { builder.harp_pedals(value, **options) }
      }.freeze
      TEMPO_CONTROLS = {
        "accelerando" => ->(builder, options) { builder.accelerando(**options) },
        "ritardando" => ->(builder, options) { builder.ritardando(**options) },
        "a_tempo" => ->(builder, options) { builder.a_tempo(**options) }
      }.freeze

      def initialize(score)
        @score = score
      end

      def build
        data = @score.data
        @builder = Production::PieceBuilder.new(data.fetch("title"), id: data.fetch("id"))
        @piece = @builder.build
        @builder.meter(data.fetch("meter"), beat_pattern: data["beat_pattern"])
        @builder.key(data.fetch("key"))
        add_parts(data.fetch("parts"))
        data.fetch("sections").each { |section| add_section(section) }
        @piece.add_tempo(data.fetch("tempo")) if data.fetch("sections").empty?
        @piece
      end

      def add_parts(parts)
        roster = Production::RosterBuilder.new(@piece)
        parts.each do |part|
          options = part.reject { |key, _| %w[id name instrument].include?(key) }.transform_keys(&:to_sym)
          options[:notation_staff] = :auto if options[:notation_staff] == "auto"
          roster.part(part.fetch("id"), part.fetch("name"), music21: part.fetch("instrument"), **options)
        end
      end

      def add_section(section)
        start = @score.section_start(section.fetch("id"))
        bars = start..(start + section.fetch("bars") - 1)
        value = section_value(section, bars)
        @piece.add_section(value)
        section_context(section, start)
        section.fetch("controls").select { |control| control["kind"] == "meter" }
               .each { |control| add_control(control, start, section.fetch("bars")) }
        section.fetch("passages").each { |passage| add_passage(value, passage, start) }
        section.fetch("controls").reject { |control| control["kind"] == "meter" }
               .each { |control| add_control(control, start, section.fetch("bars")) }
      end

      def section_value(section, bars)
        value = Production::Section.new(id: section.fetch("id"), name: section.fetch("name"), bars: bars,
                                       type: section["type"])
        value.add_journey(section["journey"]) if section["journey"]
        value.add_destination(section["destination"]) if section["destination"]
        value
      end

      def section_context(section, start)
        meter = section.fetch("meter", @score.data.fetch("meter"))
        @piece.add_meter_change(meter, at: "bar #{start}", beat_pattern: section["beat_pattern"])
        key = section.fetch("key", @score.data.fetch("key"))
        @piece.add_key_change(Production::KeyChange.new(key: key, at: "bar #{start} beat 1"))
        @piece.add_tempo(section.fetch("tempo", @score.data.fetch("tempo")), at: "bar #{start} beat 1")
      end

      def add_passage(section, passage, section_start)
        start = section_start + passage.fetch("at") - 1
        bars = start..(start + passage.fetch("bars") - 1)
        span = Production::Span.new(id: qualified_id(section.id, passage.fetch("id")), bars: bars,
                                    texture: passage["texture"])
        section.add_span(span)
        builder = Production::SpanBuilder.new(@piece, span)
        builder.harmony(passage["harmony"]) if passage["harmony"]
        builder.process(passage["purpose"]) if passage["purpose"]
        builder.chords(shift_chords(passage["chords"], start)) if passage["chords"]
        passage.fetch("voices").each { |voice| add_voice(span, section.id, passage, voice, start) }
      end

      def add_voice(span, section_id, passage, voice, start)
        id = qualified_id(section_id, passage.fetch("id"), voice.fetch("id"))
        phrase = build_phrase(id, voice)
        if phrase.events.any? { |event| event.duration <= 0 }
          raise Error.new("invalid_music", "Every note and rest needs a positive duration.")
        end
        span.add_phrase(phrase)
        bar, beat = Production.parse_location(voice.fetch("entry", "bar 1 beat 1"))
        validate_beat!(beat, start + bar - 1)
        span.add_placement(Production::Placement.new(
          id: id, phrase_id: id, part: voice.fetch("part"), role: voice.fetch("role", "foreground"),
          bar: start + bar - 1, beat: beat, anacrusis: voice["anacrusis"], realization: voice["realization"]
        ))
      end

      def build_phrase(id, voice)
        surface = voice.key?("events") ? :absolute : :degrees
        builder = Production::PhraseBuilder.new(id, surface)
        builder.events(voice.fetch("events")) if voice["events"]
        builder.degrees(voice.fetch("degrees")) if voice["degrees"]
        builder.rhythm(voice.fetch("rhythm")) if voice["rhythm"]
        builder.key_context(voice.fetch("key_context")) if voice["key_context"]
        builder.build
      end

      def qualified_id(*ids)
        "music_" + ids.map { |id| "#{id.to_s.length}_#{id}" }.join("_")
      end

      def shift_chords(text, start)
        text.gsub(/\bb(\d+)(?:-(\d+))?:/) do
          first = start + Regexp.last_match(1).to_i - 1
          last = Regexp.last_match(2)
          last ? "b#{first}-#{start + last.to_i - 1}:" : "b#{first}:"
        end
      end

      def add_control(control, start, length)
        kind = control.fetch("kind")
        options = control.reject { |key, _| %w[id kind value].include?(key) }.transform_keys(&:to_sym)
        options = control_locations(options, start, length)
        validate_control_range!(options)
        case kind
        when "meter"
          @piece.add_meter_change(control.fetch("value"), **options)
        when "tempo"
          Production::TempoBuilder.new(@piece).mark(control.fetch("value"), **options)
        when "accelerando", "ritardando", "a_tempo"
          TEMPO_CONTROLS.fetch(kind).call(Production::TempoBuilder.new(@piece), options)
        else
          add_expressive_control(kind, control, options)
        end
      end

      def validate_control_range!(options)
        return unless options[:from] && options[:to]

        first = @piece.offset_for_reference(options.fetch(:from))
        last = @piece.offset_for_reference(options.fetch(:to))
        raise Error.new("invalid_control_range", "A control must end after it begins.") unless last > first
      end

      def control_locations(options, start, length)
        %i[at from to].each do |field|
          options[field] = location(options[field], start, length, endpoint: field == :to) if options[field]
        end
        options
      end

      def add_expressive_control(kind, control, options)
        builder = Production::ControlBuilder.new(@piece)
        options[:for] = symbols(options[:for]) if options[:for]
        EXPRESSIVE.fetch(kind).call(builder, control["value"], options)
      end

      def symbols(value)
        value.is_a?(Array) ? value.map(&:to_sym) : value.to_sym
      end

      def location(text, start, length, endpoint: false)
        bar, beat = Production.parse_location(text)
        unless bar.between?(1, length) || (endpoint && bar == length + 1 && beat == 1)
          raise Error.new("control_outside_section", "Control position #{text} is outside its section.")
        end
        validate_beat!(beat, start + bar - 1)
        "bar #{start + bar - 1} beat #{beat}"
      end

      def validate_beat!(beat, bar)
        return if beat >= 1 && beat < @piece.bar_length_for(bar) + 1

        raise Error.new("invalid_beat", "Beat #{beat} is outside bar #{bar}.")
      end
    end
  end
end
