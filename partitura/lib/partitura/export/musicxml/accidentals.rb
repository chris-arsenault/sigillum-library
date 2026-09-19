# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module Accidentals
        ACCIDENTAL_NAMES = {
          -3 => "triple-flat", -2 => "flat-flat", -1 => "flat", 0 => "natural",
          1 => "sharp", 2 => "double-sharp", 3 => "triple-sharp"
        }.freeze

        private

        # Decide notation in musical time, before voices are serialized using
        # backups. Accidentals apply to one staff, step and octave for a bar.
        def prepare_measure_accidentals(voice_items, bar)
          part = rendered_parts.fetch(@current_rendered_index)
          fifths = keyless_part?(part) ? 0 : written_key_fifths(part, key_at_bar(bar.fetch(:number)))
          key_alters = Hash.new(0)
          order = fifths.negative? ? %w[B E A D G C F] : %w[F C G D A E B]
          order.take(fifths.abs).each { |step| key_alters[step] = fifths.negative? ? -1 : 1 }
          state = {}
          voice_items.flatten.group_by { |item| item.fetch(:local_offset) }.sort.each do |_offset, items|
            entries = accidental_entries(items)
            entries.group_by { |entry| entry.fetch(:identity) }.each do |identity, simultaneous|
              previous = state.fetch(identity, key_alters[identity[1]])
              alters = simultaneous.map { |entry| entry.fetch(:alter) }.uniq
              simultaneous.each do |entry|
                next if alters.length == 1 && entry.fetch(:alter) == previous

                entry.fetch(:item).fetch(:accidentals)[entry.fetch(:index)] =
                  ACCIDENTAL_NAMES.fetch(entry.fetch(:alter)) do
                    raise Error, "unsupported written accidental #{entry.fetch(:alter)}"
                  end
              end
              # Simultaneous conflicting alterations cannot establish one
              # continuing accidental; explicitly disambiguate the next note.
              state[identity] = alters.length == 1 ? alters.first : nil
            end
          end
        end

        def accidental_entries(items)
          items.flat_map do |item|
            item[:accidentals] = {}
            # A tied continuation inherits its pitch from the preceding note,
            # and does not establish a new accidental for later fresh attacks.
            next [] if tie_types_for(item).include?("stop")

            item.fetch(:pitches).each_with_index.filter_map do |pitch, index|
              next if mapped_percussion_note(pitch).first

              parsed = written_pitch(pitch)
              { item: item, index: index, alter: parsed.fetch(:alter),
                identity: [item[:staff] || 1, parsed.fetch(:step), parsed.fetch(:octave)] }
            end
          end
        end
      end
    end
  end
end
