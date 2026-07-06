# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      # SOUNDING projections: derived from the notes themselves, never from
      # declared intent (roles, harmony strings, gesture prose). These are the
      # PRIMARY analytical readouts - they report what a listener would hear
      # and work identically on composed and converted/foreign music. The
      # declared-intent projections (roles/harmony/foreground/material_map/...)
      # are secondary: they verify assertions against this ground truth.
      module SoundingReadout
        PC = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
        PC_NAMES = %w[C C# D Eb E F F# G Ab A Bb B].freeze
        DYN_ORDER = %w[ppp pp p mp mf f ff fff].freeze
        DISSONANT = [1, 2, 6, 10, 11].freeze

        def adjacency_profile(part: nil, bars: nil)
          lines = ["# Adjacency Profile (sounding)"]
          sounding_parts(part).each do |pname, evs|
            evs = evs.select { |e| in_bars?(e.offset, bars) }
            ms = evs.flat_map { |e| e.pitches.map { |p| midi_of(p) } }
            next lines << "#{pname}: (no notes)" if ms.size < 2

            iv = ms.each_cons(2).map { |a, b| (b - a).abs }
            n = iv.size.to_f
            pcs = Hash.new(0)
            ms.each { |m| pcs[m % 12] += 1 }
            top_pc = pcs.max_by { |_, c| c }
            hist = iv.tally.sort_by { |k, _| k }.map { |k, c| "#{k}:#{c}" }.join(" ")
            lines << "#{pname}: notes=#{ms.size} repeated=#{pct(iv.count(0), n)} step=#{pct(iv.count { |i| (1..2).cover?(i) }, n)} " \
                     "skip=#{pct(iv.count { |i| (3..4).cover?(i) }, n)} leap5-11=#{pct(iv.count { |i| (5..11).cover?(i) }, n)} " \
                     "leap8ve+=#{iv.count { |i| i >= 12 }}"
            lines << "  top pitch-class: #{PC_NAMES[top_pc[0]]} (#{top_pc[1]} of #{ms.size}); range #{label_of(ms.min)}-#{label_of(ms.max)}"
            lines << "  interval histogram (semitones:count): #{hist}"
          end
          lines.join("\n")
        end

        def recurrence_map_sounding(part: nil, bars: nil)
          lines = ["# Recurrence Map (sounding; bars keyed by attack bar; events crossing barlines count in their attack bar)"]
          sounding_parts(part).each do |pname, evs|
            sigs = Hash.new { |h, k| h[k] = [] }
            tsigs = Hash.new { |h, k| h[k] = [] }
            rsigs = Hash.new { |h, k| h[k] = [] }
            by_bar = evs.group_by { |e| bar_of(e.offset) }
            by_bar.each do |bar, bevs|
              next unless in_bar_number?(bar, bars)

              seq = bevs.sort_by(&:offset)
              ms = seq.map { |e| midi_of(e.pitches.first) }
              ds = seq.map { |e| e.duration }
              next if ms.empty?

              sigs[[ms, ds]] << bar
              tsigs[[ms.map { |m| m - ms.first }, ds]] << bar
              rsigs[ds] << bar
            end
            exact = sigs.values.select { |v| v.size > 1 }.sort_by(&:first)
            lines << "#{pname}:"
            lines << "  exact repeats (pitch+rhythm): #{exact.empty? ? '(none)' : exact.map(&:inspect).join(' ')}"
            trans = []
            tsigs.each_value do |group|
              next if group.size < 2

              offsets = group.map { |bar| midi_of(by_bar[bar].min_by(&:offset).pitches.first) }
              next if offsets.uniq.size == 1 # already reported as exact

              trans << group.zip(offsets).map { |bar, m| "#{bar}@#{label_of(m)}" }.join(" ")
            end
            lines << "  transposed matches (same contour+rhythm, new level): #{trans.empty? ? '(none)' : trans.join(' | ')}"
            rfams = rsigs.values.select { |v| v.size > 2 }.sort_by { |v| -v.size }.first(6)
            lines << "  rhythm-only families (>2 bars): #{rfams.map { |v| "#{v.size} bars #{v.first(12).inspect}" }.join(' | ')}"
          end
          lines.join("\n")
        end

        def peak_axes(bars: nil)
          evs = all_sounding.select { |e| in_bars?(e.offset, bars) }
          return "# Peak Axes\n(no notes)" if evs.empty?

          notes = evs.flat_map { |e| e.pitches.map { |p| [midi_of(p), e] } }
          hi = notes.max_by(&:first)
          lo = notes.min_by(&:first)
          hi_bars = notes.select { |m, _| m == hi[0] }.map { |_, e| bar_of(e.offset) }.uniq
          lo_bars = notes.select { |m, _| m == lo[0] }.map { |_, e| bar_of(e.offset) }.uniq
          longest = evs.max_by(&:duration)
          att = evs.group_by { |e| bar_of(e.offset) }.transform_values(&:size)
          dense_bar = att.max_by { |_, c| c }
          sim = evs.group_by { |e| bar_of(e.offset) }.transform_values { |g| g.map(&:part).uniq.size }
          mass_bar = sim.max_by { |_, c| c }
          dyn = dynamic_timeline
          dmax = dyn.max_by { |(_, level)| level }
          last_bar = evs.map { |e| bar_of(e.offset) }.max

          lines = ["# Peak Axes (sounding)"]
          lines << "registral max: #{label_of(hi[0])} (#{hi[1].part}) at bar#{hi_bars.size > 1 ? 's' : ''} #{hi_bars.join(', ')}#{hi_bars.size == 1 ? '  <- one-shot' : ''}"
          lines << "registral min: #{label_of(lo[0])} (#{lo[1].part}) at bar#{lo_bars.size > 1 ? 's' : ''} #{lo_bars.join(', ')}#{lo_bars.size == 1 ? '  <- one-shot' : ''}"
          lines << "longest note: #{longest.pitch_label}:#{Production.format_duration(longest.duration)} (#{longest.part}) at bar #{bar_of(longest.offset)}"
          lines << "attack-density max: bar #{dense_bar[0]} (#{dense_bar[1]} attacks)"
          lines << "active-part max: bar #{mass_bar[0]} (#{mass_bar[1]} parts)" if @piece.parts.size > 1
          if dmax
            lines << "dynamic max: #{DYN_ORDER[dmax[1]]} first at bar #{dyn.select { |(_, l)| l == dmax[1] }.map(&:first).map { |o| bar_of(o) }.min}"
          else
            lines << "dynamic max: (no dynamics found)"
          end
          per_part_high = sounding_parts(nil).map do |pname, pevs|
            pn = pevs.select { |e| in_bars?(e.offset, bars) }.flat_map { |e| e.pitches.map { |p| [midi_of(p), bar_of(e.offset)] } }
            next nil if pn.empty?

            m = pn.max_by(&:first)
            "#{pname}=#{label_of(m[0])}@b#{m[1]}"
          end.compact
          lines << "melodic high point per part: #{per_part_high.join('  ')}"
          axes = { "registral max" => hi_bars.min, "registral min" => lo_bars.min,
                   "longest note" => bar_of(longest.offset), "attack density" => dense_bar[0] }
          axes["dynamic max"] = dyn.select { |(_, l)| l == dmax[1] }.map(&:first).map { |o| bar_of(o) }.min if dmax
          lines << "axis placement (piece spans bars 1-#{last_bar}):"
          axes.sort_by { |_, b| b }.each { |name, b| lines << "  bar #{b} (#{(100.0 * b / last_bar).round}%): #{name}" }
          clusters = axes.group_by { |_, b| b }.select { |_, v| v.size > 1 }
          lines << "convergences (same bar): #{clusters.empty? ? '(none - axes separated)' : clusters.map { |b, v| "bar #{b}: #{v.map(&:first).join(' + ')}" }.join('; ')}"
          lines.join("\n")
        end

        def rhythm_profile(part: nil, bars: nil)
          lines = ["# Rhythm Profile (sounding; durations are true/tie-merged event lengths)"]
          sounding_parts(part).each do |pname, evs|
            evs = evs.select { |e| in_bars?(e.offset, bars) }
            next lines << "#{pname}: (no notes)" if evs.empty?

            hist = evs.map(&:duration).tally.sort_by { |k, _| k }
            lines << "#{pname}: duration histogram: #{hist.map { |k, c| "#{Production.format_duration(k)}:#{c}" }.join(' ')}"
            @piece.sections.each do |section|
              sevs = evs.select { |e| section.bars.cover?(bar_of(e.offset)) }
              next if sevs.empty?

              n = sevs.size.to_f
              fast = sevs.count { |e| e.duration < Rational(1, 2) }
              eighth = sevs.count { |e| e.duration == Rational(1, 2) }
              mid = sevs.count { |e| e.duration > Rational(1, 2) && e.duration <= 1 }
              long = sevs.count { |e| e.duration > 1 }
              lines << "  #{section.id} (#{section.bars.begin}-#{section.bars.end}): <8th #{pct(fast, n)}  8th #{pct(eighth, n)}  " \
                       ">8th-to-quarter #{pct(mid, n)}  longer #{pct(long, n)}"
            end
          end
          lines.join("\n")
        end

        def articulation_map(part: nil, bars: nil)
          lines = ["# Articulation Map (sounding)"]
          artic = %w[stacc accent ten marc slur( slur) arp arp:up arp:down gliss( gliss) lv trill pizz]
          sounding_parts(part).each do |pname, evs|
            evs = evs.select { |e| in_bars?(e.offset, bars) }
            marks = evs.flat_map { |e| e.marks.map(&:to_s) }
            census = artic.map { |a| [a, marks.count(a)] }.to_h
            rolls = census["arp"] + census["arp:up"] + census["arp:down"]
            lines << "#{pname}: stacc=#{census['stacc']} ten=#{census['ten']} accent=#{census['accent']} marc=#{census['marc']} " \
                     "slurs=#{census['slur(']}#{census['slur('] == census['slur)'] ? '' : " (UNBALANCED: #{census['slur)']} closes)"} " \
                     "arp=#{rolls} gliss=#{census['gliss(']}#{census['gliss('] == census['gliss)'] ? '' : " (UNBALANCED: #{census['gliss)']} closes)"} " \
                     "lv=#{census['lv']} trill=#{census['trill']} pizz=#{census['pizz']}"
            slur_lengths = slur_length_distribution(evs)
            lines << "  slur lengths (notes:count): #{slur_lengths.empty? ? '(none)' : slur_lengths.sort.map { |k, c| "#{k}:#{c}" }.join(' ')}"
            %w[stacc ten slur( accent marc arp arp:down gliss( lv].each do |mark|
              bars_with = evs.select { |e| e.marks.map(&:to_s).include?(mark) }.map { |e| bar_of(e.offset) }.uniq.sort
              next if bars_with.empty?

              lines << "  #{mark} presence: bars #{compress_ranges(bars_with)}"
            end
          end
          lines.join("\n")
        end

        def breath_map(part: nil, bars: nil)
          lines = ["# Breath Map (rests and breathless spans per part)"]
          parts = part ? [part.to_sym] : @piece.parts.keys
          parts.each do |pname|
            evs = @piece.timed_events(include_rests: true).select { |e| e.part == pname && in_bars?(e.offset, bars) }
            rests = evs.select { |e| e.rest? && e.duration >= Rational(1, 2) }
            lines << "#{pname}: rest windows >= half-beat: " +
                     (rests.empty? ? "(NONE - every breath must be stolen)" : rests.map { |r| "#{@piece.format_offset(r.offset)} len #{Production.format_duration(r.duration)}" }.join("  "))
            spans = breathless_spans(evs)
            top = spans.sort_by { |s| -s[2] }.first(3)
            lines << "  longest breathless spans: #{top.map { |a, b, d| "bars #{a}-#{b} (#{Production.format_duration(d)} ql)" }.join('  ')}" unless top.empty?
          end
          lines.join("\n")
        end

        def implied_harmony(bars: nil)
          lines = ["# Implied Harmony (sounding; per-bar CHORD CANDIDATES from duration+beat-weighted pitch classes - a reading aid, not an analysis)"]
          evs = all_sounding
          by_bar = evs.group_by { |e| bar_of(e.offset) }
          by_bar.keys.sort.each do |bar|
            next unless in_bar_number?(bar, bars)

            weights = Hash.new(0.0)
            by_bar[bar].each do |e|
              w = e.duration.to_f
              w *= 2.0 if beat_start?(e.offset)
              e.pitches.each { |p| weights[midi_of(p) % 12] += w }
            end
            cands = chord_candidates(weights).first(2)
            best = cands.first
            alt = cands[1]
            lines << "b#{bar}: #{best ? best[0] : '(?)'} (#{best ? (best[1] * 100).round : 0}% weight)#{alt ? "  alt: #{alt[0]} (#{(alt[1] * 100).round}%)" : ''}  pcs={#{weights.sort_by { |_, w| -w }.first(5).map { |pc, w| "#{PC_NAMES[pc]}:#{w.round(1)}" }.join(' ')}}"
          end
          lines.join("\n")
        end

        def ensemble_grid(bars: nil)
          evs = @piece.timed_events(include_rests: true)
          notes = evs.reject(&:rest?)
          range = bars || (1..bar_of(notes.map(&:end_offset).max - Rational(1, 100)))
          lines = ["# Ensemble Grid (16th resolution; X=attack -=sustain .=silent; beats separated by |)"]
          range.each do |bar|
            bar_start = @piece.offset_for(bar, 1)
            blen = @piece.bar_length_for(bar)
            steps = (blen / Rational(1, 4)).to_i
            beat_bounds = beat_starts(bar).map { |b| ((b - bar_start) / Rational(1, 4)).to_i }
            lines << "--- b#{bar}"
            @piece.parts.each_key do |pname|
              row = +""
              steps.times do |k|
                t = bar_start + Rational(k, 4)
                row << "|" if k.positive? && beat_bounds.include?(k)
                cell = "."
                notes.each do |e|
                  next unless e.part == pname

                  if (e.offset - t).abs < Rational(1, 100)
                    cell = "X"
                    break
                  elsif e.offset < t && e.end_offset > t
                    cell = "-"
                  end
                end
                row << cell
              end
              lines << "  #{pname.to_s.ljust(10)} #{row}"
            end
          end
          lines.join("\n")
        end

        def exposed_clashes(bars: nil)
          evs = all_sounding
          attacks = evs.map(&:offset).uniq.sort
          lines = ["# Exposed Clashes (sounding; dissonant interval-classes at attack points, severity = on-beat + naked + both-attacking)",
                   "# adjudicate before fixing: prepared suspensions, cadential V7s, pedal stacks, and resolving passing tones are correct music"]
          found = 0
          attacks.each do |t|
            next unless in_bars?(t, bars)

            sounding = evs.select { |e| e.offset <= t && e.end_offset > t }
            next if sounding.size < 2

            bar = bar_of(t)
            onbeat = beat_start?(t)
            sounding.combination(2).each do |a, b|
              next unless a.offset == t || b.offset == t

              ivs = a.pitches.product(b.pitches).map { |pa, pb| (midi_of(pa) - midi_of(pb)).abs % 12 }
              iv = ivs.find { |i| DISSONANT.include?(i) }
              next unless iv

              naked = sounding.size == 2
              both = a.offset == t && b.offset == t
              sev = (onbeat ? 2 : 0) + (naked ? 2 : 0) + (both ? 1 : 0)
              next if sev < 2

              found += 1
              lines << "b#{bar}@#{@piece.format_offset(t).split(':').last}#{onbeat ? '*' : ''} #{a.part}:#{a.pitch_label}-#{b.part}:#{b.pitch_label} " \
                       "iv#{iv}#{naked ? ' NAKED' : ''}#{both ? ' both-atk' : ''} sev#{sev}"
            end
          end
          lines << "(no findings at severity >= 2)" if found.zero?
          lines.join("\n")
        end

        def bar_profile(part: nil, bars: nil)
          lines = ["# Bar Profile (sounding; per-bar pitches, rhythm, contour, band, pitch classes)"]
          sounding_parts(part).each do |pname, evs|
            by_bar = evs.group_by { |e| bar_of(e.offset) }
            by_bar.keys.sort.each do |bar|
              next unless in_bar_number?(bar, bars)

              seq = by_bar[bar].sort_by(&:offset)
              ms = seq.flat_map { |e| e.pitches.map { |p| midi_of(p) } }
              rhythm = seq.map { |e| Production.format_duration(e.duration) }.join(" ")
              pcs = ms.map { |m| PC_NAMES[m % 12] }.uniq.join(",")
              lines << "b#{bar} [#{pname}] #{seq.map(&:pitch_label).join(' ')}"
              lines << "  rhythm: #{rhythm} | contour: #{contour_of(ms)} | band: #{label_of(ms.min)}-#{label_of(ms.max)} (#{ms.max - ms.min} semis) | pcs {#{pcs}} | attacks #{seq.size}"
            end
          end
          lines.join("\n")
        end

        def figure_timeline(part: nil, bars: nil)
          lines = ["# Figure Timeline (per-bar: rhythm-class letter + contour + register width; the anti-block scanner)"]
          sounding_parts(part).each do |pname, evs|
            by_bar = evs.group_by { |e| bar_of(e.offset) }
            classes = {}
            labels = {}
            by_bar.keys.sort.each do |bar|
              next unless in_bar_number?(bar, bars)

              seq = by_bar[bar].sort_by(&:offset)
              ds = seq.map(&:duration)
              classes[ds] ||= (classes.size % 26 + 97).chr
              ms = seq.flat_map { |e| e.pitches.map { |p| midi_of(p) } }
              span = ms.max - ms.min
              width = span >= 19 ? "W" : (span >= 12 ? "w" : "")
              labels[bar] = "#{classes[ds]}#{contour_of(ms)}#{width}"
            end
            next if labels.empty?

            lines << "#{pname}: " + labels.keys.sort.map { |b| "#{b}:#{labels[b]}" }.join(" ")
            ordered = labels.keys.sort.map { |b| labels[b] }
            lines << "  longest identical-figure run: #{longest_run(ordered)} | longest same-rhythm run: #{longest_run(ordered.map { |l| l[0] })} | rhythm classes: #{classes.size}"
            lines << "  rhythm-class legend: " + classes.map { |ds, letter| "#{letter}=[#{ds.map { |d| Production.format_duration(d) }.join(' ')}]" }.join("  ")
          end
          lines.join("\n")
        end

        private

        def contour_of(ms)
          iv = ms.each_cons(2).map { |a, b| b - a }
          return "." if iv.empty?

          rep = iv.count(0) / iv.size.to_f
          ups = iv.count(&:positive?)
          downs = iv.count(&:negative?)
          return "R" if rep > 0.5
          return "~" if ups.positive? && downs.positive? && (ups - downs).abs <= iv.size * 0.25

          ups > downs ? "/" : "\\"
        end

        def longest_run(seq)
          best = cur = 1
          seq.each_cons(2) { |a, b| cur = a == b ? cur + 1 : 1; best = [best, cur].max }
          best
        end

        def sounding_parts(part)
          groups = all_sounding.group_by(&:part)
          keys = part ? [part.to_sym] : @piece.parts.keys
          keys.filter_map { |k| groups[k] && [k, groups[k].sort_by(&:offset)] }
        end

        def all_sounding
          @all_sounding ||= @piece.timed_events.reject(&:rest?)
        end

        def midi_of(label)
          m = label.to_s.match(/\A([A-G])([#b-]*)(-?\d+)\z/)
          raise ArgumentError, "bad pitch label #{label.inspect}" unless m

          semis = PC.fetch(m[1])
          m[2].each_char { |c| semis += c == "#" ? 1 : -1 }
          semis + 12 * (m[3].to_i + 1)
        end

        def label_of(midi)
          "#{PC_NAMES[midi % 12]}#{midi / 12 - 1}"
        end

        def pct(count, total)
          "#{(100.0 * count / total).round}%"
        end

        def bar_of(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = @piece.bar_length_for(bar)
            break if Rational(offset) < bar_start + length

            bar_start += length
            bar += 1
          end
          bar
        end

        def in_bar_number?(number, bars)
          !bars || bars.include?(number)
        end

        def beat_starts(bar)
          blen = @piece.bar_length_for(bar)
          pattern = @piece.meter_for(bar).beat_pattern || [1] * blen.to_i
          total = pattern.sum
          start = @piece.offset_for(bar, 1)
          acc = Rational(0)
          pattern.map do |p|
            s = start + acc
            acc += blen * Rational(p, total)
            s
          end
        end

        def beat_start?(offset)
          bar = bar_of(offset)
          beat_starts(bar).any? { |b| (b - Rational(offset)).abs < Rational(1, 100) }
        end

        def dynamic_timeline
          out = []
          @piece.controls.each do |c|
            next unless c.kind.to_s == "dynamic"

            level = DYN_ORDER.index(c.value.to_s)
            out << [@piece.offset_for_reference(c.at), level] if level
          end
          all_sounding.each do |e|
            e.marks.each do |m|
              level = DYN_ORDER.index(m.to_s)
              out << [e.offset, level] if level
            end
          end
          out.sort_by(&:first)
        end

        def slur_length_distribution(evs)
          dist = Hash.new(0)
          depth = 0
          count = 0
          evs.sort_by(&:offset).each do |e|
            marks = e.marks.map(&:to_s)
            count += 1 if depth.positive? || marks.include?("slur(")
            depth += marks.count("slur(")
            closes = marks.count("slur)")
            next unless closes.positive? && depth.positive?

            depth -= closes
            if depth <= 0
              dist[count] += 1 if count > 1
              depth = 0
              count = 0
            end
          end
          dist
        end

        def breathless_spans(evs)
          # A breath is an explicit rest >= a half-beat OR a silent GAP between
          # events (unplaced stretches have no rest events at all).
          notes = evs.reject(&:rest?).sort_by(&:offset)
          spans = []
          run_start = nil
          run_end = nil
          notes.each do |e|
            if run_end && e.offset - run_end >= Rational(1, 2)
              spans << [bar_of(run_start), bar_of(run_end - Rational(1, 100)), run_end - run_start]
              run_start = nil
            end
            run_start ||= e.offset
            run_end = [run_end, e.end_offset].compact.max
          end
          spans << [bar_of(run_start), bar_of(run_end - Rational(1, 100)), run_end - run_start] if run_start
          spans
        end

        CHORD_TEMPLATES = {
          "" => [0, 4, 7], "m" => [0, 3, 7], "dim" => [0, 3, 6], "aug" => [0, 4, 8],
          "7" => [0, 4, 7, 10], "m7" => [0, 3, 7, 10], "maj7" => [0, 4, 7, 11],
          "dim7" => [0, 3, 6, 9], "m7b5" => [0, 3, 6, 10]
        }.freeze

        def chord_candidates(weights)
          total = weights.values.sum
          return [] if total <= 0

          scored = []
          12.times do |root|
            CHORD_TEMPLATES.each do |suffix, degrees|
              pcs = degrees.map { |d| (root + d) % 12 }
              covered = pcs.sum { |pc| weights[pc] }
              # penalize big templates lightly so triads win ties
              scored << ["#{PC_NAMES[root]}#{suffix}", covered / total - degrees.size * 0.005]
            end
          end
          scored.sort_by { |_, s| -s }
        end

        def compress_ranges(nums)
          nums.slice_when { |a, b| b > a + 1 }.map { |g| g.size > 1 ? "#{g.first}-#{g.last}" : g.first.to_s }.join(", ")
        end
      end
    end
  end
end
