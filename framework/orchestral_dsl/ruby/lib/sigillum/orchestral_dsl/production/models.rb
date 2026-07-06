# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class CompileError < StandardError
        attr_reader :response

        def initialize(code:, message:, repair_instruction:, help_topic:, docs:, minimal_example: nil)
          @response = {
            status: "error",
            code: code,
            message: message,
            repair_instruction: repair_instruction,
            help_topic: help_topic,
            docs: docs,
            minimal_example: minimal_example
          }.compact
          super(message)
        end
      end

      module PitchEvent
        def rest?
          pitch.nil? || pitch == []
        end

        def note?
          !rest? && !chord?
        end

        def chord?
          pitch.is_a?(Array)
        end

        def event_type
          return "rest" if rest?

          chord? ? "chord" : "note"
        end

        def pitches
          return [] if rest?

          chord? ? pitch : [pitch]
        end

        def pitch_label
          return "r" if rest?

          chord? ? "[#{pitch.join(',')}]" : pitch
        end

        def marks
          Array(local_marks)
        end
      end

      Event = Struct.new(:pitch, :duration, :source, :local_marks, keyword_init: true) do
        include PitchEvent

        def to_s
          Production.event_token(self)
        end
      end

      TimedEvent = Struct.new(:part, :role, :phrase_id, :pitch, :duration, :offset, :source,
                              :transform, :realization, :local_marks, keyword_init: true) do
        include PitchEvent

        def end_offset
          offset + duration
        end
      end

      Anchor = Struct.new(:id, :at, keyword_init: true)

      Control = Struct.new(:kind, :value, :at, :from, :to, :target, keyword_init: true)

      KeyChange = Struct.new(:key, :at, keyword_init: true)

      MeterEvent = Struct.new(:meter, :beat_pattern, :bar, keyword_init: true)

      TempoEvent = Struct.new(:kind, :text, :at, :from, :to, :bpm, keyword_init: true)

      class Part
        attr_reader :id, :name, :music21_instrument, :family, :range, :description, :notation_group, :notation_staff

        def initialize(id:, name:, music21_instrument:, family: nil, range: nil, description: nil, notation_group: nil, notation_staff: nil)
          @id = id.to_sym
          @name = name
          @music21_instrument = music21_instrument.to_s
          @family = family&.to_sym
          @range = range
          @description = description
          @notation_group = notation_group&.to_sym
          @notation_staff = notation_staff
        end
      end

      class Phrase
        attr_reader :id, :surface, :events

        def initialize(id:, surface:, events:)
          @id = id.to_sym
          @surface = surface.to_sym
          @events = events.freeze
        end

        def duration
          @events.sum { |event| event.duration }
        end
      end

      class Placement
        attr_reader :phrase_id, :part, :role, :bar, :beat, :transform, :realization

        def initialize(phrase_id:, part:, role:, bar:, beat:, transform: nil, realization: nil)
          @phrase_id = phrase_id.to_sym
          @part = part.to_sym
          @role = role.to_sym
          @bar = Integer(bar)
          @beat = Rational(beat)
          @transform = transform
          @realization = realization
        end
      end

      class Gesture
        attr_reader :id, :idea_text, :mechanism_texts, :audible_texts, :line_relations,
                    :orchestration_texts, :silence_texts, :note_texts

        def initialize(id:)
          @id = id.to_sym
          @idea_text = nil
          @mechanism_texts = []
          @audible_texts = []
          @line_relations = []
          @orchestration_texts = []
          @silence_texts = []
          @note_texts = []
        end

        attr_writer :idea_text

        def add_mechanism(text)
          @mechanism_texts << text.to_s
        end

        def add_audible(text)
          @audible_texts << text.to_s
        end

        def add_line_relation(left, right, text)
          @line_relations << { left: left.to_sym, right: right.to_sym, text: text.to_s }
        end

        def add_orchestration(text)
          @orchestration_texts << text.to_s
        end

        def add_silence(text)
          @silence_texts << text.to_s
        end

        def add_note(text)
          @note_texts << text.to_s
        end

        def supported?
          !@mechanism_texts.empty? || !@audible_texts.empty? || !@line_relations.empty? ||
            !@orchestration_texts.empty? || !@silence_texts.empty?
        end
      end

      class StaffLane
        attr_reader :role, :part, :tokens

        def initialize(role:, text:)
          @role = role.to_sym
          part_text, token_text = text.to_s.split(":", 2)
          if token_text.nil?
            @part = nil
            @tokens = tokenize_words(part_text)
          else
            @part = part_text.strip.to_sym
            @tokens = tokenize_words(token_text)
          end
        end

        private

        def tokenize_words(text)
          text.to_s.split(/\s+/).reject(&:empty?)
        end
      end

      class StaffBar
        attr_reader :number, :lanes, :checks

        def initialize(number)
          @number = Integer(number)
          @lanes = []
          @checks = []
        end

        def add_lane(role, text)
          @lanes << StaffLane.new(role: role, text: text)
        end

        def add_check(text)
          @checks << text.to_s
        end
      end

      class Span
        attr_reader :bars, :texture, :harmony_texts, :process_texts, :phrases,
                    :phrase_definitions, :placements, :staff_bars, :gestures

        def initialize(bars:, texture: nil)
          @bars = bars
          @texture = texture&.to_sym
          @harmony_texts = []
          @process_texts = []
          @phrases = {}
          @phrase_definitions = []
          @placements = []
          @staff_bars = []
          @gestures = []
        end

        def add_harmony(text)
          @harmony_texts << text.to_s
        end

        def add_process(text)
          @process_texts << text.to_s
        end

        def add_phrase(phrase)
          @phrase_definitions << phrase
          @phrases[phrase.id] ||= phrase
        end

        def add_placement(placement)
          @placements << placement
        end

        def add_staff_bar(staff_bar)
          @staff_bars << staff_bar
        end

        def add_gesture(gesture)
          @gestures << gesture
        end
      end

      class Section
        attr_reader :id, :name, :bars, :type, :journey_texts, :destination_texts, :spans,
                    :gestures

        def initialize(id:, name:, bars:, type: nil)
          @id = id.to_sym
          @name = name
          @bars = bars
          @type = type&.to_sym
          @journey_texts = []
          @destination_texts = []
          @spans = []
          @gestures = []
        end

        def add_journey(text)
          @journey_texts << text.to_s
        end

        def add_destination(text)
          @destination_texts << text.to_s
        end

        def add_span(span)
          @spans << span
        end

        def add_gesture(gesture)
          @gestures << gesture
        end
      end

      class Piece
        attr_reader :title, :meter_value, :beat_pattern, :bar_length, :key_value, :tempo_marks,
                    :meter_changes, :tempo_events, :anchors, :controls, :key_changes, :parts, :sections

        def initialize(title)
          @title = title
          @meter_value = "4/4"
          @beat_pattern = nil
          @bar_length = Rational(4)
          @key_value = "C"
          @meter_changes = []
          @tempo_marks = []
          @tempo_events = []
          @anchors = {}
          @controls = []
          @key_changes = []
          @parts = {}
          @sections = []
        end

        def set_meter(value, beat_pattern: nil)
          @meter_value = value.to_s
          @beat_pattern = beat_pattern
          @bar_length = Production.meter_to_bar_length(@meter_value)
        end

        def add_meter_change(value, at:, beat_pattern: nil)
          bar = Production.parse_bar_boundary(at)
          if bar == 1
            set_meter(value, beat_pattern: beat_pattern)
            return
          end

          @meter_changes << MeterEvent.new(
            meter: value.to_s,
            beat_pattern: beat_pattern,
            bar: bar
          )
        end

        def set_key(value)
          @key_value = value.to_s
        end

        def add_tempo(text, at: "bar 1 beat 1")
          @tempo_marks << text.to_s
          @tempo_events << TempoEvent.new(
            kind: :mark,
            text: text.to_s,
            at: at,
            bpm: Production.bpm_from_text(text)
          )
        end

        def add_tempo_event(event)
          @tempo_events << event
        end

        def add_anchor(id, at:)
          @anchors[id.to_sym] = Anchor.new(id: id.to_sym, at: at)
        end

        def add_control(control)
          @controls << control
        end

        def add_key_change(key_change)
          @key_changes << key_change
        end

        def add_part(part)
          @parts[part.id] = part
        end

        def add_section(section)
          @sections << section
        end

        def phrases
          out = {}
          origins = {}
          @sections.each do |section|
            section.spans.each do |span|
              span.phrase_definitions.each do |phrase|
                id = phrase.id
                if out.key?(id)
                  first_origin = origins.fetch(id)
                  second_origin = "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
                  raise compile_error(
                    code: "duplicate_phrase_id",
                    message: "Phrase id #{id} is defined more than once: #{first_origin} and #{second_origin}.",
                    repair_instruction: "Rename phrases so every phrase id is unique across the production piece.",
                    help_topic: "phrase_placement",
                    docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
                  )
                end
                out[id] = phrase
                origins[id] = "#{section.id} bars #{span.bars.begin}-#{span.bars.end}"
              end
            end
          end
          out
        end

        def placements
          @sections.flat_map { |section| section.spans.flat_map(&:placements) }
        end

        def staff_bars
          @sections.flat_map { |section| section.spans.flat_map(&:staff_bars) }
        end

        def gestures
          @sections.flat_map { |section| section.gestures + section.spans.flat_map(&:gestures) }
        end

        def total_duration
          return 0 if @sections.empty?

          @sections.map { |section| offset_for(section.bars.end + 1, 1) }.max
        end

        def offset_for(bar, beat)
          bar = Integer(bar)
          offset = Rational(0)
          (1...bar).each { |number| offset += bar_length_for(number) }
          offset + Rational(beat) - 1
        end

        def offset_for_reference(reference)
          case reference
          when Symbol
            anchor = @anchors.fetch(reference) do
              raise compile_error(
                code: "unknown_anchor",
                message: "Location references unknown anchor #{reference}.",
                repair_instruction: "Declare the anchor before using it in a control or tempo event.",
                help_topic: "controls",
                docs: ["docs/architecture/orchestral_dsl/surfaces/controls.md"]
              )
            end
            offset_for_reference(anchor.at)
          when String
            bar, beat = Production.parse_location(reference)
            offset_for(bar, beat)
          else
            Rational(reference)
          end
        end

        def timed_events(include_rests: false)
          phrase_map = phrases
          placements.flat_map do |placement|
            unless @parts.key?(placement.part)
              raise compile_error(
                code: "unknown_part",
                message: "Placement references unknown part #{placement.part}.",
                repair_instruction: "Add the part to the roster or fix the placement part id.",
                help_topic: "container",
                docs: ["docs/architecture/orchestral_dsl/01_container.md"]
              )
            end
            phrase = phrase_map.fetch(placement.phrase_id) do
              raise compile_error(
                code: "unknown_phrase",
                message: "Placement references unknown phrase #{placement.phrase_id}.",
                repair_instruction: "Define the phrase before placing it, or fix the phrase id.",
                help_topic: "phrase_placement",
                docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
              )
            end
            offset = offset_for(placement.bar, placement.beat)
            phrase.events.filter_map do |event|
              current = TimedEvent.new(
                part: placement.part,
                role: placement.role,
                phrase_id: phrase.id,
                pitch: event.pitch,
                duration: event.duration,
                offset: offset,
                source: event.source,
                transform: placement.transform,
                realization: placement.realization,
                local_marks: event.marks
              )
              offset += event.duration
              include_rests || !current.rest? ? current : nil
            end
          end.sort_by { |event| [event.offset, event.part.to_s, event.pitch.to_s] }
        end

        def validate!
          validate_meter_events!
          validate_spans_and_placements!
          events = timed_events(include_rests: true)
          validate_tempo_events!
          validate_controls!(events)
          validate_key_changes!
          true
        end

        def compile_response
          validate!
          {
            status: "ok",
            source_model: "production_hybrid",
            surface_summary: phrases.values.map(&:surface).uniq.map(&:to_s),
            available_projections: %w[
              adjacency_profile recurrence_map peak_axes rhythm_profile articulation_map
              breath_map implied_harmony ensemble_grid exposed_clashes bar_profile figure_timeline
              line verticals grid timed_events controls transport
            ],
            secondary_declared_intent_projections: %w[
              structure roles phrases placements staff_bars foreground bass_path
              harmony harmony_with_melody material_map gesture_map
            ],
            projection_note: "available_projections are SOUNDING (note-derived) and primary; " \
                             "secondary views read authored assertions and only verify them against the music",
            available_exports: %w[transport_json musicxml midi],
            next_help_topics: %w[projections hybrid controls transport_export],
            docs: ["docs/architecture/orchestral_dsl/INDEX.md"]
          }
        rescue CompileError => e
          e.response
        end

        def format_offset(offset)
          offset = Rational(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = bar_length_for(bar)
            break if offset < bar_start + length

            bar_start += length
            bar += 1
          end
          beat = offset - offset_for(bar, 1) + 1
          "b#{bar}:#{Production.format_duration(beat)}"
        end

        def meter_timeline
          [MeterEvent.new(meter: @meter_value, beat_pattern: @beat_pattern, bar: 1)] +
            @meter_changes.sort_by(&:bar)
        end

        def meter_for(bar)
          meter_timeline.select { |event| event.bar <= bar }.max_by(&:bar)
        end

        def bar_length_for(bar)
          Production.meter_to_bar_length(meter_for(Integer(bar)).meter)
        end

        private

        def compile_error(**kwargs)
          CompileError.new(**kwargs)
        end

        def validate_meter_events!
          seen = {}
          @meter_changes.each do |event|
            Production.meter_to_bar_length(event.meter)
            if seen.key?(event.bar)
              raise compile_error(
                code: "duplicate_meter_change",
                message: "More than one meter change is declared at bar #{event.bar}.",
                repair_instruction: "Keep at most one meter event per bar.",
                help_topic: "container",
                docs: ["docs/architecture/orchestral_dsl/01_container.md"]
              )
            end
            seen[event.bar] = true
          end
        end

        def validate_spans_and_placements!
          @sections.each do |section|
            section.spans.each do |span|
              unless section.bars.cover?(span.bars.begin) && section.bars.cover?(span.bars.end)
                raise compile_error(
                  code: "span_outside_section",
                  message: "Span bars #{span.bars.begin}-#{span.bars.end} are outside section #{section.id} bars #{section.bars.begin}-#{section.bars.end}.",
                  repair_instruction: "Keep span bars inside the containing section.",
                  help_topic: "container",
                  docs: ["docs/architecture/orchestral_dsl/01_container.md"]
                )
              end

              span.placements.each do |placement|
                next if span.bars.cover?(placement.bar)

                raise compile_error(
                  code: "placement_outside_span",
                  message: "Placement #{placement.phrase_id} at bar #{placement.bar} is outside span bars #{span.bars.begin}-#{span.bars.end}.",
                  repair_instruction: "Move the placement into the containing span or place it in a span that covers that bar.",
                  help_topic: "phrase_placement",
                  docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
                )
              end
            end
          end
        end

        def validate_tempo_events!
          @tempo_events.each do |event|
            if event.at
              offset_for_reference(event.at)
            else
              offset_for_reference(event.from)
              offset_for_reference(event.to)
            end
          end
        end

        def validate_key_changes!
          @key_changes.each { |kc| offset_for_reference(kc.at) }
        end

        def validate_controls!(events)
          @controls.each do |control|
            if control.at
              offset_for_reference(control.at)
            else
              offset_for_reference(control.from)
              offset_for_reference(control.to)
            end

            unmatched = unmatched_control_selectors(control.target, events)
            next if unmatched.empty?

            raise compile_error(
              code: "unknown_control_target",
              message: "Control target #{unmatched.join(', ')} does not match any part, family, or role.",
              repair_instruction: "Use an existing part id, family, role, :all, or a list of those selectors.",
              help_topic: "controls",
              docs: ["docs/architecture/orchestral_dsl/surfaces/controls.md"]
            )
          end
        end

        def control_target_parts(target, events)
          return @parts.keys if target == :all || target.to_s == "all"

          selectors = target.is_a?(Array) ? target : [target]
          selectors.flat_map { |selector| parts_matching_selector(selector, events) }.uniq
        end

        def unmatched_control_selectors(target, events)
          return @parts.empty? ? ["all"] : [] if target == :all || target.to_s == "all"

          selectors = target.is_a?(Array) ? target : [target]
          selectors.select { |selector| parts_matching_selector(selector, events).empty? }.map(&:to_s)
        end

        def parts_matching_selector(selector, events)
          selector_text = selector.to_s
          direct_matches = @parts.values.filter_map do |part|
            next part.id if part.id.to_s == selector_text
            next part.id if part.family&.to_s == selector_text
            next part.id if part.name.to_s == selector_text
          end
          return direct_matches unless direct_matches.empty?

          events.filter_map do |event|
            event.part if event.role.to_s == selector_text && @parts.key?(event.part)
          end
        end
      end
    end
  end
end
