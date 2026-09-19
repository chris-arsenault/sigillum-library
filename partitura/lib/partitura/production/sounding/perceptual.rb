# frozen_string_literal: true

require_relative "perceptual_dynamics"
require_relative "perceptual_timing"

module Partitura
  module Production
    module SoundingReadout
      # Perceptual projections: a virtual render. Every sounding event expands
      # into a cloud of harmonic partials via per-instrument spectral recipes,
      # dynamic markings become levels, tempo makes decay real, and the views
      # report what a listener would contend with - band crowding, masking,
      # sensory roughness, beat salience, entry binding, audible ring - as
      # text. Recipes are caricatures on purpose: coarse spectral placement
      # and decay are what these defects depend on, and the table is the
      # calibration surface (correct a recipe when listening disagrees).
      module Perceptual
        Partial = Struct.new(:part, :midi, :freq, :onset, :notated_end, :audible_end,
                             :amp, :tau, :attack, keyword_init: true)
        Envelope = Struct.new(:part, :onset, :audible_end, :amp, :tau, :attack_count, keyword_init: true)

        RECIPES = {
          "SteelDrum" => { partials: [1.0, 0.55, 0.3, 0.12], ring: 3.0 },
          "Percussion" => { partials: [1.0, 0.5, 0.25], ring: 1.5 },
          "Harp" => { partials: [1.0, 0.6, 0.4, 0.28, 0.2, 0.14, 0.1, 0.07], ring: 2.2 },
          "Piano" => { partials: [1.0, 0.6, 0.4, 0.28, 0.2, 0.14, 0.1, 0.07], ring: 2.5 },
          "Soprano" => { partials: [1.0, 0.55, 0.35, 0.45, 0.3, 0.15, 0.1, 0.06] },
          "Alto" => { partials: [1.0, 0.55, 0.35, 0.45, 0.3, 0.15, 0.1, 0.06] },
          "Tenor" => { partials: [1.0, 0.55, 0.35, 0.45, 0.3, 0.15, 0.1, 0.06] },
          "Bass" => { partials: [1.0, 0.55, 0.35, 0.45, 0.3, 0.15, 0.1, 0.06] },
          "Clarinet" => { partials: [1.0, 0.06, 0.5, 0.05, 0.33, 0.04, 0.2, 0.03, 0.12] },
          "BassClarinet" => { partials: [1.0, 0.06, 0.5, 0.05, 0.33, 0.04, 0.2, 0.03, 0.12] }
        }.freeze
        FAMILY_RECIPES = {
          voice: RECIPES.fetch("Soprano"),
          plucked: RECIPES.fetch("Harp"),
          percussion: RECIPES.fetch("Percussion"),
          pitched_percussion: RECIPES.fetch("SteelDrum")
        }.freeze
        DEFAULT_RECIPE = { partials: (1..8).map { |n| 1.0 / n } }.freeze

        FLOOR_DB = -48
        RING_FLOOR = 0.04
        LV_RING_CAP_S = 4.0
        STEP = Rational(1, 4)

        BAND_EDGES_HZ = [0, 80, 120, 180, 260, 380, 550, 800, 1200, 1800, 2700, 4000].freeze
        BAND_LABELS = %w[<80 80 120 180 260 380 550 800 1.2k 1.8k 2.7k 4k+].freeze

        def spectrum_grid(bars: nil)
          lines = ["# Spectrum Grid (virtual render; rows = frequency bands, cols = #{STEP} ql slots, " \
                   "digit = level 1-9 log scale)"]
          append_pitch_scope(lines, spectral: true)
          each_selected_bar(bars) do |bar, start, length|
            slots = (length / STEP).to_i
            grid = band_level_grid(start, length, slots)
            next if grid.all? { |row| row.all? { |v| v <= 0.0 } }

            lines << "--- b#{bar}"
            grid.each_with_index.reverse_each do |row, band|
              cells = row.map { |amp| level_digit(amp) }.join
              lines << format("  %5s %s", BAND_LABELS[band], cells)
            end
          end
          lines.join("\n")
        end

        def masking_report(bars: nil, part: nil)
          lines = ["# Masking Report (virtual render; best fundamental-band attack share per part/bar; " \
                   "BURIED <15%, at risk <28%; sustained audibility needs separate review)"]
          append_pitch_scope(lines, spectral: true)
          flagged = 0
          each_selected_bar(bars) do |bar, start, length|
            attack_shares(start, length).each do |pname, (share, band, dominators)|
              next if part && pname != part.to_sym
              next if share >= 0.28

              flagged += 1
              lines << format("b%d %s %s: best attack share %d%% @%s band (masked by %s)",
                              bar, pname, share < 0.15 ? "BURIED" : "at risk",
                              (share * 100).round, BAND_LABELS[band], dominators.join(","))
            end
          end
          lines << (flagged.zero? ? "no buried parts in selection" : "#{flagged} flagged bar-parts")
          lines.join("\n")
        end

        def roughness_profile(bars: nil)
          lines = ["# Roughness Profile (virtual render; Plomp-Levelt sensory dissonance per slot, " \
                   "digits 0-9; worst instants listed with their partial owners)"]
          append_pitch_scope(lines, spectral: true)
          worst = []
          each_selected_bar(bars) do |bar, start, length|
            slots = (length / STEP).to_i
            values = Array.new(slots) do |i|
              t = start + (STEP * i)
              rough, pair = slot_roughness(t)
              worst << [rough, bar, t, pair] if pair
              rough
            end
            lines << format("b%-3d %s", bar, values.map { |v| roughness_digit(v) }.join)
          end
          worst.sort_by! { |entry| -entry[0] }
          worst.first(5).each do |rough, _bar, t, (a, b)|
            lines << format("  peak %s @%s: %s %s vs %s %s", roughness_digit(rough),
                            @piece.format_offset(t), a.part, label_of(a.midi), b.part, label_of(b.midi))
          end
          lines.join("\n")
        end

        def beat_salience(bars: nil)
          lines = ["# Beat Salience (virtual render; squared attack amplitudes by phase, including unpitched attacks; " \
                   "off-beat peaks are review flags, not errors)"]
          phase_energy = Hash.new(0.0)
          bar_flags = []
          each_selected_bar(bars) do |bar, start, length|
            per_phase = attack_energy_by_phase(start, length)
            per_phase.each { |phase, energy| phase_energy[phase] += energy }
            strongest = per_phase.max_by { |_, energy| energy }
            next unless strongest && strongest[1].positive?

            bar_flags << "b#{bar} strongest attack at +#{format_phase(strongest[0])} ql " \
                         "(off the macro-beats)" unless macro_phases(bar).include?(strongest[0])
          end
          max_energy = phase_energy.values.max.to_f
          phase_energy.keys.sort.each do |phase|
            width = max_energy.positive? ? ((phase_energy[phase] / max_energy) * 30).round : 0
            lines << format("  +%-5s %s", format_phase(phase), width.zero? ? "." : "#" * width)
          end
          lines.concat(bar_flags)
          lines << "#{bar_flags.length} bars whose strongest attack is off the macro-beats"
          lines.join("\n")
        end

        def binding_check(bars: nil)
          lines = ["# Binding Check (virtual render; flags off-beat entries without a nearby held call " \
                   "or ensemble attack; deliberate scene cuts require score judgment)"]
          if @piece.parts.keys.any? { |name| unpitched_part?(name) }
            lines << "# Unpitched parts supply attack/grid binding, never pitch-distance calls."
          end
          unbound = 0
          entries_in(bars).each do |event, phase, bar|
            next if macro_phases(bar).include?(phase)
            next if grid_locked?(event)
            next if co_attacked?(event)

            call = nearest_call(event)
            verdict, detail = binding_verdict(event, call)
            next if verdict == :bound

            unbound += 1
            lines << format("%s %s %s enters UNBOUND: %s",
                            @piece.format_offset(event.offset), event.part,
                            event.pitches.join("/"), detail)
          end
          lines << (unbound.zero? ? "all off-beat entries bind" : "#{unbound} unbound entries")
          lines.join("\n")
        end

        def ringing_grid(bars: nil)
          lines = ["# Ringing Grid (virtual render; X = attack, digits = audible level while " \
                   "ringing or sustaining, . = inaudible; lv rings past the notated duration)"]
          if @piece.parts.keys.any? { |name| unpitched_part?(name) }
            lines << "# Unpitched attacks are retained; their decay uses a generic percussion envelope, not device spectra."
          end
          each_selected_bar(bars) do |bar, start, length|
            slots = (length / STEP).to_i
            lines << "--- b#{bar}"
            @piece.parts.each_key do |pname|
              row = Array.new(slots) do |i|
                t = start + (STEP * i)
                ring_cell(pname, t)
              end
              lines << format("  %-13s %s", pname, row.join)
            end
          end
          lines.join("\n")
        end

        private

        def perceptual_cloud
          @perceptual_cloud ||= pitched_sounding.flat_map { |event| event_partials(event) }
                                            .sort_by(&:freq)
        end

        # Attack timing and decay do not require a pitched fundamental. Keep
        # them for drum-map events without assigning pitches to device labels.
        def perceptual_envelopes
          @perceptual_envelopes ||= all_sounding.map do |event|
            ring = recipe_for(event.part)[:ring]
            tau = ring && (ring / 3.0)
            Envelope.new(part: event.part, onset: event.offset,
                         audible_end: audible_end_for(event, tau), amp: event_level(event),
                         tau: tau, attack_count: event.pitches.length)
          end
        end

        def event_partials(event)
          recipe = recipe_for(event.part)
          level = event_level(event)
          ring = recipe[:ring]
          tau = ring && (ring / 3.0)
          event.pitches.filter_map { |pitch| pitch_partials(event, pitch, recipe, level, tau) }.flatten
        end

        def pitch_partials(event, pitch, recipe, level, tau)
          base = midi_of(pitch)
          audible_end = audible_end_for(event, tau)
          recipe[:partials].each_with_index.map do |amp, index|
            Partial.new(
              part: event.part, midi: base, freq: hz_of(base) * (index + 1),
              onset: event.offset, notated_end: event.end_offset, audible_end: audible_end,
              amp: level * amp, tau: tau, attack: index.zero?
            )
          end
        end

        def audible_end_for(event, tau)
          return event.end_offset unless tau

          ring_seconds = [-Math.log(RING_FLOOR) * tau, LV_RING_CAP_S].min
          ring_end = perceptual_timing.offset_at(perceptual_timing.seconds_at(event.offset) + ring_seconds)
          if event.marks.map(&:to_s).include?("lv")
            ring_end
          else
            [event.end_offset, ring_end].min
          end
        end

        def recipe_for(part_name)
          part = @piece.parts[part_name]
          return DEFAULT_RECIPE unless part

          RECIPES[part.music21_instrument.to_s] ||
            FAMILY_RECIPES[part.family&.to_sym] ||
            DEFAULT_RECIPE
        end

        def event_level(event)
          db = dynamic_db_for(event.part, event.offset)
          marks = event.marks.map(&:to_s)
          db = -3 if marks.include?("fp")
          db = 0 if marks.include?("sfz")
          db += 4 if marks.include?("accent")
          db += 6 if marks.include?("marc")
          db += Marks::GHOST_ATTENUATION_DB if marks.include?("ghost")
          10.0**(db / 20.0)
        end

        def dynamic_db_for(part_name, offset)
          perceptual_dynamics.level(part_name, offset)
        end

        def perceptual_dynamics
          @perceptual_dynamics ||= PerceptualDynamics.new(@piece)
        end

        def perceptual_timing
          @perceptual_timing ||= PerceptualTiming.new(@piece)
        end

        def partial_amp_at(partial, time)
          return 0.0 if time < partial.onset || time >= partial.audible_end

          unless partial.tau
            change = dynamic_db_for(partial.part, time) - dynamic_db_for(partial.part, partial.onset)
            return partial.amp * (10.0**(change / 20.0))
          end

          elapsed = perceptual_timing.seconds_at(time) - perceptual_timing.seconds_at(partial.onset)
          partial.amp * Math.exp(-elapsed / partial.tau)
        end

        def hz_of(midi)
          440.0 * (2.0**((midi - 69) / 12.0))
        end

        def band_of(freq)
          index = BAND_EDGES_HZ.rindex { |edge| freq >= edge } || 0
          [index, BAND_LABELS.length - 1].min
        end

        def level_digit(amp)
          return "." if amp <= 0.0

          db = 20 * Math.log10(amp)
          return "." if db < FLOOR_DB

          [((db - FLOOR_DB) / -FLOOR_DB * 9).round, 9].min.clamp(1, 9).to_s
        end

        def roughness_digit(value)
          [(value * 45).round, 9].min.to_s
        end

        def each_selected_bar(bars)
          start = Rational(0)
          bar = 1
          total = @piece.total_duration
          while start < total
            length = @piece.bar_length_for(bar)
            yield(bar, start, length) if in_bars?(start, bars)
            start += length
            bar += 1
          end
        end

        def band_level_grid(start, length, slots)
          grid = Array.new(BAND_LABELS.length) { Array.new(slots, 0.0) }
          slots.times do |i|
            t = start + (STEP * i)
            perceptual_cloud.each do |partial|
              amp = partial_amp_at(partial, t)
              next if amp <= 0.0

              grid[band_of(partial.freq)][i] += amp
            end
          end
          grid
        end

        # For each part that attacks in the bar: at each of its attack instants,
        # measure its share of the energy in its fundamental's band. A note is
        # judged where and when it must speak; the part's best attack is kept.
        def attack_shares(start, length)
          verdicts = {}
          attacks_by_part(start, length).each do |pname, attacks|
            best = attacks.map { |partial| attack_share_at(partial) }.max_by(&:first)
            verdicts[pname] = best if best
          end
          verdicts
        end

        def attacks_by_part(start, length)
          perceptual_cloud.select { |p| p.attack && p.onset >= start && p.onset < start + length }
                          .group_by(&:part)
        end

        def attack_share_at(attack)
          band = band_of(attack.freq)
          energy = Hash.new(0.0)
          self_energy = 0.0
          perceptual_cloud.each do |partial|
            next unless band_of(partial.freq) == band

            amp = partial_amp_at(partial, attack.onset)
            next unless amp.positive?

            if partial.part == attack.part || reinforces?(partial, attack)
              self_energy += amp**2
            else
              energy[partial.part] += amp**2
            end
          end
          total = self_energy + energy.values.sum
          return [1.0, band, []] if total <= 0.0

          dominators = energy.sort_by { |_, value| -value }.first(2).map(&:first)
          [self_energy / total, band, dominators]
        end

        # A unison or octave partner on the same pitch reinforces the note
        # rather than masking it.
        def reinforces?(partial, attack)
          diff = (partial.midi - attack.midi).abs
          diff.zero? || diff == 12
        end

        # Roughness normalized by the loudness present: naked dissonance in a
        # bare texture is MORE salient than the same interval inside a tutti.
        def slot_roughness(time)
          active = perceptual_cloud.filter_map do |partial|
            amp = partial_amp_at(partial, time)
            [partial, amp] if amp > 0.005
          end
          total = 0.0
          worst = 0.0
          worst_pair = nil
          active.each_with_index do |(a, amp_a), i|
            active[(i + 1)..].each do |b, amp_b|
              break if b.freq - a.freq > 300

              next if a.part == b.part && a.midi == b.midi

              value = plomp_levelt(a.freq, b.freq) * [amp_a, amp_b].min
              total += value
              worst, worst_pair = value, [a, b] if value > worst && a.part != b.part
            end
          end
          loudness = active.sum { |_, amp| amp }
          [loudness.positive? ? total / loudness : 0.0, worst_pair]
        end

        def plomp_levelt(freq_a, freq_b)
          fmin = [freq_a, freq_b].min
          s = 0.24 / ((0.021 * fmin) + 19.0)
          x = s * (freq_a - freq_b).abs
          Math.exp(-3.5 * x) - Math.exp(-5.75 * x)
        end

        def attack_energy_by_phase(start, length)
          per_phase = Hash.new(0.0)
          perceptual_envelopes.each do |envelope|
            next unless envelope.onset >= start && envelope.onset < start + length

            per_phase[envelope.onset - start] += envelope.attack_count * envelope.amp**2
          end
          per_phase
        end

        def entries_in(bars)
          all_sounding.filter_map do |event|
            next unless in_bars?(event.offset, bars)

            previous = previous_sounding_event(event.part, event.offset)
            next if previous && event.offset - previous.end_offset < 1

            bar = bar_of(event.offset)
            [event, phase_of(event.offset), bar]
          end
        end

        def phase_of(offset)
          bar = bar_of(offset)
          Rational(offset) - offset_of_bar(bar)
        end

        def macro_phases(bar)
          beat_starts(bar).map { |offset| offset - offset_of_bar(bar) }
        end

        def format_phase(phase)
          value = phase.to_f
          value == value.to_i ? value.to_i.to_s : format("%.2f", value).sub(/0+\z/, "")
        end

        def offset_of_bar(bar)
          start = Rational(0)
          (1...bar).each { |number| start += @piece.bar_length_for(number) }
          start
        end

        def grid_locked?(event)
          grid_part = busiest_part
          return false if grid_part == event.part

          all_sounding.any? do |other|
            other.part == grid_part && (other.offset - event.offset).abs < STEP
          end
        end

        def busiest_part
          @busiest_part ||= all_sounding.group_by(&:part).max_by { |_, events| events.length }&.first
        end

        def nearest_call(event)
          return nil if unpitched_part?(event.part)

          held = pitched_sounding.select do |other|
            other.part != event.part && other.offset < event.offset &&
              other.end_offset > event.offset
          end
          held.min_by { |other| (event_midi(other) - event_midi(event)).abs }
        end

        # Attacking together with another part is ensemble, not orphanhood.
        def co_attacked?(event)
          all_sounding.any? do |other|
            other.part != event.part && (other.offset - event.offset).abs < STEP
          end
        end

        def binding_verdict(event, call)
          return [:unbound, "unpitched entry has no nearby ensemble attack"] if unpitched_part?(event.part)
          return [:unbound, "no pitched call is sounding to answer"] unless call

          distance = (event_midi(call) - event_midi(event)).abs
          gap = (event.offset - call.offset).to_f
          if distance <= 19 && gap <= 1.5
            [:bound, nil]
          else
            [:unbound, format("nearest call %s %s is %d semitones away, attacked %.2f ql earlier",
                              call.part, call.pitches.join("/"), distance, gap)]
          end
        end

        def ring_cell(part_name, time)
          attack = false
          level = 0.0
          perceptual_envelopes.each do |envelope|
            next unless envelope.part == part_name

            attack ||= envelope.onset >= time && envelope.onset < time + STEP
            amp = partial_amp_at(envelope, time)
            level = amp if amp > level
          end
          return "X" if attack
          return "." if level <= 0.0

          digit = level_digit(level)
          digit == "." ? "." : digit
        end
      end
    end
  end
end
