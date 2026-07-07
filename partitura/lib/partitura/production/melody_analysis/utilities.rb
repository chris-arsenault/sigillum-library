# frozen_string_literal: true

module Partitura
  module Production
    class MelodyAnalysis
      module Utilities
        MAJOR_LIKE_MODES = %w[major ionian lydian mixolydian].freeze

        private

        def in_bars?(offset)
          !bars || bars.include?(bar_of(offset))
        end

        def bar_of(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = piece.bar_length_for(bar)
            break if Rational(offset) < bar_start + length

            bar_start += length
            bar += 1
          end
          bar
        end

        def bar_count
          notes.map { |note| note.features.fetch(:metric).fetch(:bar) }.uniq.length
        end

        def scope_suffix
          bits = []
          bits << "part=#{part}" if part
          bits << "bars=#{bars.begin}-#{bars.end}" if bars
          bits.empty? ? "" : " [#{bits.join(', ')}]"
        end

        # The declared piece key wins; the Krumhansl estimate stays as a cross-check.
        def declared_key
          return nil unless piece.respond_to?(:key_declared?) && piece.key_declared?

          parsed = Production.parse_key_context(piece.key_value)
          mode = MAJOR_LIKE_MODES.include?(parsed.fetch(:mode)) ? :major : :minor
          [parsed.fetch(:tonic_midi) % 12, mode]
        rescue CompileError
          nil
        end

        def key_label
          label = "#{PC_NAMES[key[0]]} #{key[1]}"
          return "#{label} (estimated - declare `key` to pin it)" unless declared_key
          return "#{label} (declared)" if @estimated_key == key

          "#{label} (declared; estimate hears #{estimated_key_label} - check accidentals or the key declaration)"
        end

        def declared_key_label
          declared = declared_key
          declared && "#{PC_NAMES[declared[0]]} #{declared[1]}"
        end

        def estimated_key_label
          "#{PC_NAMES[@estimated_key[0]]} #{@estimated_key[1]}"
        end

        def midi_of(label)
          match = label.to_s.match(/\A([A-G])([#b-]*)(-?\d+)\z/)
          raise ArgumentError, "bad pitch label #{label.inspect}" unless match

          semis = PC.fetch(match[1])
          match[2].each_char { |char| semis += char == "#" ? 1 : -1 }
          semis + (12 * (match[3].to_i + 1))
        end

        def label_of(midi)
          "#{PC_NAMES[midi % 12]}#{(midi / 12) - 1}"
        end

        def mean(values)
          return 0.0 if values.empty?

          values.sum.to_f / values.length
        end

        def median(values)
          sorted = values.sort
          middle = sorted.length / 2
          sorted.length.odd? ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2.0
        end

        def tally(values)
          values.each_with_object(Hash.new(0)) { |value, out| out[value] += 1 }
                .sort_by { |key, count| [-count, key.to_s] }.to_h
        end

        def hash_preview(hash, limit)
          return "none" if hash.empty?

          hash.first(limit).map { |key, value| "#{key}=#{value}" }.join(", ")
        end

        def percent(count, total)
          "#{(100.0 * count / total).round}%"
        end
      end
    end
  end
end
