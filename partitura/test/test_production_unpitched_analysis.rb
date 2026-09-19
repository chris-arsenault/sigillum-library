# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionUnpitchedAnalysisTest < Minitest::Test
  def test_mapped_kit_does_not_invent_spectral_masking_or_harmonic_pitches
    bass_only = analysis_piece(extra: nil)
    with_kit = analysis_piece

    %i[spectrum_grid masking_report roughness_profile].each do |view|
      report = Partitura.production_readout(with_kit, view)
      assert_includes report, "Pitched parts only; excludes unpitched parts: kit."
      assert_includes report, "Unpitched spectra and masking are not modeled."
      assert_equal report_body(bass_only, view), report_body(with_kit, view)
    end

    %i[implied_harmony harmony_check exposed_clashes].each do |view|
      assert_equal report_body(bass_only, view), report_body(with_kit, view)
    end
    refute_includes Partitura.production_readout(with_kit, :implied_harmony), "F#:"
    refute_match(/peak .*kit/, Partitura.production_readout(with_kit, :roughness_profile))
  end

  def test_pitched_percussion_stays_in_spectral_and_harmonic_analysis
    bass_only = analysis_piece(extra: nil)
    with_pan = analysis_piece(extra: :pitched)

    refute_equal report_body(bass_only, :spectrum_grid), report_body(with_pan, :spectrum_grid)
    assert_includes Partitura.production_readout(with_pan, :implied_harmony), "F#:"
    assert_match(/peak .*kit/, Partitura.production_readout(with_pan, :roughness_profile))
    refute_includes Partitura.production_readout(with_pan, :roughness_profile), "Pitched parts only"
  end

  def test_unpitched_attack_energy_and_ringing_are_retained
    piece = analysis_piece
    beat = Partitura.production_readout(piece, :beat_salience)
    ringing = Partitura.production_readout(piece, :ringing_grid)
    row = ringing[/kit\s+(\S+)/, 1]

    assert_includes beat, "b1 strongest attack at +0.5 ql (off the macro-beats)"
    assert_includes ringing, "generic percussion envelope, not device spectra"
    assert_equal "..X", row[0, 3]
    assert_equal 1, row.count("X")
    assert_match(/[1-9]/, row[3..], "let-ring drum envelope must survive after its written release")
    assert_includes Partitura.production_readout(piece, :ensemble_grid), "kit        ..X."
  end

  def test_held_unpitched_label_cannot_bind_a_pitched_entry_by_interval
    piece = analysis_piece(bass_events: "r:.5 D2:.25 r:3.25", kit_events: "C2:2 r:2")

    report = Partitura.production_readout(piece, :binding_check)

    assert_includes report, "bass D2 enters UNBOUND: no pitched call is sounding to answer"
    assert_includes report, "Unpitched parts supply attack/grid binding, never pitch-distance calls."
  end

  def test_concurrent_drum_and_bass_attacks_still_bind
    piece = analysis_piece(bass_events: "r:.5 D2:.25 r:3.25", kit_events: "r:.5 C2:.25 r:3.25")

    assert_includes Partitura.production_readout(piece, :binding_check), "all off-beat entries bind"
  end

  def test_unpitched_entry_is_not_bound_by_a_held_bass_pitch
    piece = analysis_piece(kit_events: "r:.5 C2:.25 r:3.25")

    assert_includes Partitura.production_readout(piece, :binding_check),
                    "kit C2 enters UNBOUND: unpitched entry has no nearby ensemble attack"
  end

  private

  def report_body(piece, view)
    Partitura.production_readout(piece, view).lines.reject { |line| line.start_with?("#") }.join
  end

  def analysis_piece(extra: :unpitched, bass_events: "D2:4{p}",
                     kit_events: "r:.5 [C2,E2,F#2]:.25{fff,lv} r:3.25")
    Partitura::Production.piece("Unpitched Analysis Boundary") do
      meter "4/4"
      key "D"
      tempo "quarter = 60"
      roster do
        part :bass, "Electric Bass", music21: "ElectricBass", family: :string
        if extra == :unpitched
          part :kit, "Drum Kit", music21: "Percussion", family: :percussion,
            percussion_map: {
              "C2" => :concert_bass_drum,
              "E2" => :electric_snare,
              "F#2" => :closed_hi_hat
            }
        elsif extra == :pitched
          part :kit, "Steel Pan", music21: "SteelDrum", family: :pitched_percussion
        end
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          chords "b1:D"
          phrase(:bass_line, surface: :absolute) { events bass_events }
          placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :foreground
          if extra
            phrase(:kit_line, surface: :absolute) { events kit_events }
            placement :kit_line, part: :kit, at: "bar 1 beat 1", role: :rhythm
          end
        end
      end
    end
  end
end
