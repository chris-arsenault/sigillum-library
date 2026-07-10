# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceModelAnalysisTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_model_export_data_is_backend_ready
    piece = load_piece
    data = Partitura::Production.export_data(piece)

    assert_model_data_header(data)
    assert_model_data_parts(data)
    assert_model_data_events(data)
  end

  def assert_model_data_header(data)
    assert_equal "Production Hybrid Surface Study", data.fetch(:title)
    assert_equal "7/8", data.fetch(:meter)
    assert_equal 28.0, data.fetch(:total_duration_ql)
  end

  def assert_model_data_parts(data)
    assert_equal(%w[clarinet solo_violin cello hand_drum], data.fetch(:parts).map { |part| part.fetch(:id) })
    assert_equal(%w[Clarinet Violin Violoncello Percussion], data.fetch(:parts).map { |part|
 part.fetch(:music21_instrument) })
  end

  def assert_model_data_events(data)
    assert_includes data.fetch(:phrases).map { |phrase| phrase.fetch(:id) }, "plain_call"
    assert(data.fetch(:timed_events).any? { |event|
 event.fetch(:offset_label) == "b1:1" && event.fetch(:pitch) == "C5" })
    assert(data.fetch(:timed_events).all? { |event|
 event.key?(:event_type) && event.key?(:pitches) && event.key?(:pitch_label) })
    assert_equal "not_prose_only", data.fetch(:gestures).first.fetch(:id)
  end

  def test_model_metrics_replace_card_metrics_script_as_dsl_model
    piece = metrics_piece

    metrics = Partitura.production_metrics(piece)
    assert_equal "Metric model", metrics.fetch(:name)
    assert_equal(
      { attacks: 3, onset_vocab: 3, duration_vocab: 2, pitch_vocab: 2 },
      metrics.fetch(:parts).fetch("flute")
    )
    assert_equal(
      { attacks: 2, onset_vocab: 2, duration_vocab: 1, pitch_vocab: 3 },
      metrics.fetch(:parts).fetch("cello")
    )

    readout = Partitura.production_readout(piece, :metrics)
    assert_includes readout, "# Model Metrics Metric model"
    assert_includes readout, "flute                attacks   3 onsets  3 durations  2 pitches   2"
    assert_includes piece.compile_response.fetch(:available_projections), "metrics"
  end

  def test_melody_analysis_replaces_python_analysis_scripts_as_dsl_model
    piece = melody_analysis_piece

    analysis = Partitura.production_melody_analysis(piece, part: :flute)
    assert_equal "Melody analysis model", analysis.fetch(:title)
    assert_equal :flute, analysis.fetch(:part)
    assert_equal "C5", analysis.fetch(:melody_notes).first.fetch(:pitch)
    assert_equal 1, analysis.fetch(:melody_notes).first.fetch(:tonal).fetch(:degree)

    readout = Partitura.production_readout(piece, :melody_analysis, part: :flute)
    assert_includes readout, "# Melody Analysis Melody analysis model [part=flute]"
    assert_includes readout, "per-note (offset | part | pitch | degree | roman role | figure | motif):"
    assert_includes readout, "b1:1"

    report = Partitura.production_readout(piece, :melody_report, part: :flute)
    assert_includes report, "# Melody Report Melody analysis model [part=flute]"
    assert_includes report, "motif/hook"
    assert_includes report, "implies:"
    assert_includes piece.compile_response.fetch(:available_projections), "melody_analysis"
    assert_includes piece.compile_response.fetch(:available_projections), "melody_report"
  end

  def test_musicxml_import_is_a_ruby_model_with_convert_and_verify_results
    Dir.mktmpdir do |dir|
      path = File.join(dir, "hand.musicxml")
      File.write(path, MINIMAL_IMPORT_MUSICXML)

      conversion = Partitura.production_musicxml_import(
        path,
        bars: 1..1,
        segments: "opening:1-1",
        beats: 4
      )
      render = conversion.render

      assert_equal 1..1, conversion.to_h.fetch(:bars)
      assert_equal "C5", conversion.to_h.fetch(:parts).fetch("flute").first.fetch(:pitch)
      assert_includes render, "#### flute ####"
      assert_includes render, "-- opening (bars 1-1):"
      assert_includes render, "C5:1{mf,txt:cantabile,stacc} D5:1"
      assert_includes render, 'text "C", at: "bar 1 beat 1", for: :all'

      verification = Partitura.production_musicxml_import_verify(path, path, bars: 1..1, beats: 4)
      assert verification.ok?
      assert_equal 0, verification.total_differing_bars
      assert_includes verification.render, "flute: OK"
    end
  end

  def test_musicxml_import_verify_reports_mismatched_note_content
    Dir.mktmpdir do |dir|
      hand_path = File.join(dir, "hand.musicxml")
      export_path = File.join(dir, "export.musicxml")
      File.write(hand_path, MINIMAL_IMPORT_MUSICXML)
      File.write(export_path, MINIMAL_IMPORT_MUSICXML.sub("<step>C</step>", "<step>E</step>"))

      verification = Partitura.production_musicxml_import_verify(hand_path, export_path, bars: 1..1, beats: 4)

      refute verification.ok?
      assert_equal 1, verification.total_differing_bars
      assert_includes verification.render, "flute: DIFF at bars [1]"
    end
  end

  def test_musicxml_import_preserves_metronome_augmentation_dots
    Dir.mktmpdir do |dir|
      { 1 => "dotted-quarter=84", 2 => "double-dotted-quarter=84" }.each do |dots, expected|
        path = File.join(dir, "#{dots}-dots.musicxml")
        dot_elements = Array.new(dots, "<beat-unit-dot/>").join("\n              ")
        xml = MINIMAL_IMPORT_MUSICXML.sub(
          "<beat-unit>quarter</beat-unit>",
          "<beat-unit>quarter</beat-unit>\n              #{dot_elements}"
        )
        File.write(path, xml)

        conversion = Partitura.production_musicxml_import(path, bars: 1..1, beats: 4)
        tempo = conversion.to_h.fetch(:meta).find { |row| row.fetch(:kind) == "tempo" }

        assert_equal expected, tempo.fetch(:text)
      end
    end
  end

  def test_musicxml_import_preserves_approximate_dotted_metronome_text
    Dir.mktmpdir do |dir|
      path = File.join(dir, "approximate-dotted.musicxml")
      xml = MINIMAL_IMPORT_MUSICXML
            .sub("<beat-unit>quarter</beat-unit>", "<beat-unit>quarter</beat-unit>\n              <beat-unit-dot/>")
            .sub("<per-minute>84</per-minute>", "<per-minute>c. 84</per-minute>")
      File.write(path, xml)

      conversion = Partitura.production_musicxml_import(path, bars: 1..1, beats: 4)
      tempo = conversion.to_h.fetch(:meta).find { |row| row.fetch(:kind) == "tempo" }

      assert_equal "dotted-quarter=c. 84", tempo.fetch(:text)
      assert_equal 126, Partitura::Production.bpm_from_text(tempo.fetch(:text))
    end
  end

  private

  def metrics_piece
    Partitura::Production.piece("Metric model") do
      meter "4/4"; key "C"
      roster {
 part :flute, "Flute", music21: "Flute", family: :woodwind;
 part :cello, "Cello", music21: "Violoncello", family: :string }
      section :s1, "Metrics", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C5:1 D5:.5 C5:.5 r:2" }
          phrase(:cello_line, surface: :absolute) { events "[C3,E3]:2 G2:2" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end

  def melody_analysis_piece
    Partitura::Production.piece("Melody analysis model") do
      meter "4/4"; key "C"
      roster {
 part :flute, "Flute", music21: "Flute", family: :woodwind;
 part :cello, "Cello", music21: "Violoncello", family: :string }
      section :s1, "Analysis", bars: 1..2 do
        span bars: 1..2 do
          phrase(:flute_line, surface: :absolute) { events "C5:1 D5:1 E5:1 G5:.5 A5:.5 | G5:1 E5:1 D5:1 C5:1" }
          phrase(:cello_support, surface: :absolute) { events "[C3,E3,G3]:4 | [G2,B2,D3,F3]:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :cello_support, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end
end
