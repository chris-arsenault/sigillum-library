# frozen_string_literal: true

module Partitura
  module Production
    # Lint rules sit between compiler errors and musical judgment: they flag authoring
    # shapes that tend to produce unreadable or mis-surfaced source. `warn` lints never
    # block; `error`-level lints fail the compile response. Thresholds are configurable
    # per piece:
    #
    #   lint do
    #     rule :phrase_length, warn: 12, error: 32
    #     rule :surface_nudges, enabled: false
    #   end
    module Lint
      DEFAULTS = {
        phrase_length: { enabled: true, warn: 8, error: 24 },
        surface_nudges: { enabled: true }
      }.freeze

      NUDGE_MIN_NOTES = 8
      NUDGE_MIN_PITCH_CLASSES = 4
      DIATONIC_FIT = 0.9
      CELL_LENGTH = 4
      MAJOR_SET = [0, 2, 4, 5, 7, 9, 11].freeze

      module_function

      def run(piece)
        config = effective_config(piece)
        lints = []
        phrases = piece.phrases
        lints.concat(phrase_length_lints(piece, phrases, config.fetch(:phrase_length)))
        lints.concat(surface_nudge_lints(phrases)) if config.fetch(:surface_nudges).fetch(:enabled)
        lints
      end

      def effective_config(piece)
        overrides = piece.respond_to?(:lint_config) ? piece.lint_config : {}
        DEFAULTS.each_with_object({}) do |(rule, defaults), out|
          out[rule] = defaults.merge(overrides[rule] || {})
        end
      end

      def render(piece)
        lints = run(piece)
        return "# Lint\n(clean)" if lints.empty?

        lines = ["# Lint (#{lints.count { |l| l[:level] == 'error' }} error, " \
                 "#{lints.count { |l| l[:level] == 'warn' }} warn)"]
        lints.each { |lint| lines << "#{lint[:level].upcase} #{lint[:rule]} #{lint[:phrase]}: #{lint[:message]}" }
        lines.join("\n")
      end

      def phrase_length_lints(piece, phrases, config)
        return [] unless config.fetch(:enabled)

        placements_by_phrase = piece.placements.group_by(&:phrase_id)
        phrases.each_value.filter_map do |phrase|
          bars = phrase_bar_span(piece, phrase, placements_by_phrase[phrase.id])
          phrase_length_lint(phrase, bars, config)
        end
      end

      def phrase_length_lint(phrase, bars, config)
        level = if bars > config.fetch(:error)
                  "error"
                elsif bars > config.fetch(:warn)
                  "warn"
                end
        return nil unless level

        {
          rule: "phrase_length", level: level, phrase: phrase.id,
          message: "spans #{bars} bars (warn > #{config.fetch(:warn)}, error > #{config.fetch(:error)}). " \
                   "Split it into named sub-phrases placed in sequence: shorter phrases keep the streams " \
                   "readable and let recurrence_map/material_map show returns.",
          help_topic: "phrase_placement"
        }
      end

      def phrase_bar_span(piece, phrase, placements)
        if placements.nil? || placements.empty?
          (phrase.duration / piece.bar_length).ceil
        else
          placements.map { |placement| placed_bar_span(piece, phrase, placement) }.max
        end
      end

      def placed_bar_span(piece, phrase, placement)
        start = piece.offset_for(placement.bar, placement.beat)
        finish = start + phrase.duration
        last_bar = bar_at(piece, finish - Rational(1, 1000))
        last_bar - placement.bar + 1
      end

      def bar_at(piece, offset)
        bar = 1
        bar_start = Rational(0)
        loop do
          length = piece.bar_length_for(bar)
          break if offset < bar_start + length

          bar_start += length
          bar += 1
        end
        bar
      end

      def surface_nudge_lints(phrases)
        phrases.each_value.flat_map do |phrase|
          next [] unless %i[absolute split_pitch_rhythm].include?(phrase.surface)

          notes = single_line_midis(phrase)
          next [] if notes.length < NUDGE_MIN_NOTES

          [degrees_nudge(phrase, notes), intervals_nudge(phrase, notes)].compact
        end
      end

      def single_line_midis(phrase)
        return [] if phrase.events.any?(&:chord?)

        phrase.events.reject(&:rest?).map { |event| Production.pitch_to_midi(event.pitch) }
      end

      def degrees_nudge(phrase, notes)
        classes = notes.map { |midi| midi % 12 }
        return nil if classes.uniq.length < NUDGE_MIN_PITCH_CLASSES

        return nil unless diatonic_fit?(classes)

        {
          rule: "surface_nudge", level: "warn", phrase: phrase.id,
          message: "single mostly-diatonic line written as #{phrase.surface}. If scale function or cadence " \
                   "tendency matters here, pitch: :degrees exposes it; keep #{phrase.surface} only when exact " \
                   "register/spelling is the musical object.",
          help_topic: "degrees"
        }
      end

      def diatonic_fit?(classes)
        (0..11).any? do |tonic|
          scale = MAJOR_SET.map { |step| (tonic + step) % 12 }
          classes.count { |pc| scale.include?(pc) } >= classes.length * DIATONIC_FIT
        end
      end

      def intervals_nudge(phrase, notes)
        seq = notes.each_cons(2).map { |a, b| b - a }
        return nil unless repeated_cell?(seq)

        {
          rule: "surface_nudge", level: "warn", phrase: phrase.id,
          message: "contains a repeated (possibly transposed) #{CELL_LENGTH}-note cell written as " \
                   "#{phrase.surface}. If the cell's identity/transformation is the musical object, " \
                   "pitch: :intervals shows it directly.",
          help_topic: "intervals"
        }
      end

      def repeated_cell?(seq)
        windows = {}
        seq.each_cons(CELL_LENGTH - 1).with_index do |window, index|
          first = windows[window]
          return true if first && index >= first + (CELL_LENGTH - 1)

          windows[window] ||= index
        end
        false
      end
    end
  end
end
