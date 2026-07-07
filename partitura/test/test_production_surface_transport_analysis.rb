# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceTransportAnalysisTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_transport_hash_is_versioned_and_backend_ready
    piece = load_piece
    transport = Partitura.production_transport_hash(piece)

    assert_transport_header(transport)
    assert_transport_parts(transport)
    assert_transport_events(transport)
  end

  def assert_transport_header(transport)
    assert_equal "partitura.transport", transport.fetch(:schema)
    assert_equal 3, transport.fetch(:schema_version)
    assert_equal "Production Hybrid Surface Study", transport.fetch(:title)
    assert_equal "7/8", transport.fetch(:meter)
    assert_equal 28.0, transport.fetch(:total_duration_ql)
  end

  def assert_transport_parts(transport)
    assert_equal(%w[clarinet solo_violin cello hand_drum], transport.fetch(:parts).map { |part| part.fetch(:id) })
    assert_equal(%w[Clarinet Violin Violoncello Percussion], transport.fetch(:parts).map { |part|
 part.fetch(:music21_instrument) })
  end

  def assert_transport_events(transport)
    assert_includes transport.fetch(:phrases).map { |phrase| phrase.fetch(:id) }, "plain_call"
    assert(transport.fetch(:timed_events).any? { |event|
 event.fetch(:offset_label) == "b1:1" && event.fetch(:pitch) == "C5" })
    assert(transport.fetch(:timed_events).all? { |event|
 event.key?(:event_type) && event.key?(:pitches) && event.key?(:pitch_label) })
    assert_equal "not_prose_only", transport.fetch(:gestures).first.fetch(:id)
  end

  def test_transport_metrics_replace_card_metrics_script_as_dsl_model
    piece = transport_metrics_piece

    metrics = Partitura.production_transport_metrics(piece)
    assert_equal "Metric model", metrics.fetch(:name)
    assert_equal(
      { attacks: 3, onset_vocab: 3, duration_vocab: 2, pitch_vocab: 2 },
      metrics.fetch(:parts).fetch("flute")
    )
    assert_equal(
      { attacks: 2, onset_vocab: 2, duration_vocab: 1, pitch_vocab: 3 },
      metrics.fetch(:parts).fetch("cello")
    )

    readout = Partitura.production_readout(piece, :transport_metrics)
    assert_includes readout, "# Transport Metrics Metric model"
    assert_includes readout, "flute                attacks   3 onsets  3 durations  2 pitches   2"
    assert_includes piece.compile_response.fetch(:available_projections), "transport_metrics"
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

  private

  def transport_metrics_piece
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
          phrase(:flute_line, surface: :absolute) { events "C5:1 D5:1 E5:1 G5:.5 A5:.5 G5:1 E5:1 D5:1 C5:1" }
          phrase(:cello_support, surface: :absolute) { events "[C3,E3,G3]:4 [G2,B2,D3,F3]:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :cello_support, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end
end
