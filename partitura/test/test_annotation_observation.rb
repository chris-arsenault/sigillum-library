# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class AnnotationObservationTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura", "bin", "partitura")
  SCORE = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <score-partwise version="4.0">
      <part-list>
        <score-part id="P1"><part-name>flute1</part-name></score-part>
        <score-part id="P2"><part-name>violin1</part-name></score-part>
      </part-list>
      <part id="P1">
        <measure number="1">
          <attributes><divisions>1</divisions><time><beats>4</beats><beat-type>4</beat-type></time></attributes>
          <note><pitch><step>C</step><octave>5</octave></pitch><duration>4</duration></note>
        </measure>
        <measure number="2"><note><pitch><step>D</step><octave>5</octave></pitch><duration>4</duration></note></measure>
        <measure number="3"><note><pitch><step>E</step><octave>5</octave></pitch><duration>4</duration></note></measure>
      </part>
      <part id="P2">
        <measure number="1">
          <attributes><divisions>1</divisions><time><beats>4</beats><beat-type>4</beat-type></time></attributes>
          <note><pitch><step>C</step><octave>5</octave></pitch><duration>4</duration></note>
        </measure>
        <measure number="2"><note><pitch><step>G</step><octave>4</octave></pitch><duration>4</duration></note></measure>
        <measure number="3"><note><pitch><step>E</step><octave>5</octave></pitch><duration>4</duration></note></measure>
      </part>
    </score-partwise>
  XML

  def test_openscore_profile_binds_parts_events_relations_and_seams
    with_observation do |directory, observation_path|
      projection = Partitura.annotation_observation(
        observation_path,
        profile: "openscore_hauptstimme_v1",
        annotations: openscore_sources(directory)
      )

      assert_equal 1, projection.fetch("schema_version")
      assert_equal "partitura-annotation-observation-v1-r1", projection.fetch("projector")
      assert_match(/\Asha256:[0-9a-f]{64}\z/, projection.fetch("annotation_observation_digest"))
      assert_equal 2, projection.dig("summary", "target_counts", "prominent_part")
      assert_equal 2, projection.dig("summary", "target_counts", "structural_part_relation")
      assert_equal 2, projection.dig("summary", "target_counts", "seam_boundary")
      prominent = projection.fetch("examples").find do |example|
        example["target"] == "prominent_part" && example.dig("scope", "part_id") == "P1"
      end
      assert_equal ["event:P1:1:1"], prominent.dig("scope", "annotation_event_ids")
      assert_equal "P1", prominent.dig("scope", "part_id")
    end
  end

  def test_s3_profile_binds_form_harmony_cadence_roles_and_temporal_audits
    with_observation do |directory, observation_path|
      sources = s3_sources(directory)

      projection = Partitura.annotation_observation(
        observation_path,
        profile: "s3_v1",
        annotations: sources
      )

      assert_equal 2, projection.dig("summary", "target_counts", "form_section")
      assert_equal 1, projection.dig("summary", "target_counts", "cadence_type")
      assert_equal 2, projection.dig("summary", "target_counts", "harmonic_function")
      assert_equal 2, projection.dig("summary", "target_counts", "orchestral_role")
      assert_equal 3, projection.fetch("audits").length
      assert(projection.fetch("audits").all? { |audit| audit.fetch("passed") })
      roles = projection.fetch("examples").select { |example| example["target"] == "orchestral_role" }
      assert_equal %w[harm+mel rhythm], roles.map { |role| role.fetch("label") }.sort
      assert(roles.all? { |role| role.dig("scope", "part_id") == "P1" })
    end
  end

  def test_reports_excluded_source_rows_without_inventing_examples
    with_observation do |directory, observation_path|
      annotations = write(
        directory,
        "annotations.csv",
        "qstamp,measure,beat,measure_fraction,label,part,part_num,instrument\n" \
        "0,1,1,0,a,Flute,0,Flute\n"
      )
      relations = write(
        directory,
        "relations.csv",
        "qstamp_start,qstamp_end,flute1,violin1\n" \
        "qstamp_start,qstamp_end,flute1,violin1\n" \
        "20,24,Main Part,U(Main)\n"
      )

      projection = Partitura.annotation_observation(
        observation_path,
        profile: "openscore_hauptstimme_v1",
        annotations: [
          { kind: "hauptstimme_annotations", path: annotations },
          { kind: "part_relations", path: relations }
        ]
      )

      codes = projection.fetch("warnings").map { |warning| warning.fetch("code") }
      assert_equal %w[annotation_span_outside_score repeated_csv_header], codes.sort
      assert_equal 1, projection.dig("summary", "target_counts", "prominent_part")
      assert_nil projection.dig("summary", "target_counts", "structural_part_relation")
      assert_equal 0, projection.dig("summary", "binding_failure_count")
      assert_equal 1, projection.dig("summary", "failed_audit_count")
    end
  end

  def test_s3_retains_form_without_claiming_missing_material_identity
    with_observation do |directory, observation_path|
      sources = s3_sources(
        directory,
        form: "phrase onset,phrase offset,section,theme\n0,4,opening,\n4,12,closing,\n"
      )

      projection = Partitura.annotation_observation(
        observation_path,
        profile: "s3_v1",
        annotations: sources
      )

      assert_equal 2, projection.dig("summary", "target_counts", "form_section")
      assert_nil projection.dig("summary", "target_counts", "material_recurrence")
      warnings = projection.fetch("warnings").select do |warning|
        warning.fetch("code") == "missing_material_label"
      end
      assert_equal 2, warnings.length
    end
  end

  def test_cli_emits_annotation_observation
    with_observation do |directory, observation_path|
      annotations = write(
        directory,
        "annotations.csv",
        "qstamp,measure,beat,measure_fraction,label,part,part_num,instrument\n0,1,1,0,a,Flute,0,Flute\n"
      )
      relations = write(
        directory,
        "relations.csv",
        "qstamp_start,qstamp_end,flute1,violin1\n0,12,Main Part,U(Main)\n"
      )
      stdout, stderr, status = Open3.capture3(
        "ruby",
        CLI,
        "annotation-observation",
        observation_path,
        "--profile",
        "openscore_hauptstimme_v1",
        "--annotation",
        "hauptstimme_annotations=#{annotations}",
        "--annotation",
        "part_relations=#{relations}"
      )

      assert status.success?, stderr
      assert_equal "openscore_hauptstimme_v1", JSON.parse(stdout).fetch("profile")
    end
  end

  def test_rejects_tampered_parent_observation
    with_observation do |_directory, observation_path|
      document = JSON.parse(File.read(observation_path))
      document["summary"]["event_count"] += 1
      File.write(observation_path, JSON.pretty_generate(document))

      error = assert_raises(Partitura::AnnotationObservation::Error) do
        Partitura.annotation_observation(
          observation_path,
          profile: "s3_v1",
          annotations: []
        )
      end

      assert_equal "score_observation_digest_mismatch", error.code
    end
  end

  def test_unknown_profile_error_routes_to_runtime_profile_catalog
    error = assert_raises(Partitura::AnnotationObservation::Error) do
      Partitura.annotation_observation(
        "unused.json",
        profile: "not_a_profile",
        annotations: []
      )
    end
    response = error.to_h

    assert_equal "unknown_annotation_profile", response.fetch(:code)
    assert_includes response.fetch(:message), "openscore_hauptstimme_v1"
    assert_equal "annotation_observation", response.fetch(:help_topic)
    assert_includes response.fetch(:repair_instruction), "catalog annotation-profiles"
  end

  private

  def with_observation
    Dir.mktmpdir do |directory|
      score_path = write(directory, "score.musicxml", SCORE)
      observation_path = write(
        directory,
        "observation.json",
        JSON.pretty_generate(Partitura.score_observation(score_path))
      )
      yield directory, observation_path
    end
  end

  def s3_sources(directory, form: nil)
    {
      s3_form: form || "phrase onset,phrase offset,section,theme\n0,4,opening,a\n4,12,closing,a\n",
      s3_cadence: "onset,resolve time,offset,cadence type\n2,1,4,HC\n",
      s3_harmony: "onset,offset,key,degree,quality,inversion,roman number\n0,4,C,1,M,0,I\n4,12,C,5,D7,0,V7\n",
      s3_orchestral_texture: "onset,offset,role\n0,4,mel+harm\n4,12,rhythm\n",
      s3_downbeats: "onset\n0\n4\n8\n",
      s3_time_signature: "onset,measure,time_signature_quarter_length," \
                         "time_signature_numerator,time_signature_denominator\n" \
                         "0,1,4,4,4\n"
    }.flat_map do |kind, content|
      path = if kind == :s3_orchestral_texture
               write(directory, "flute1.csv", content)
             else
               write(directory, "#{kind}.csv", content)
             end
      [{ kind: kind.to_s, path: path }]
    end + [
      {
        kind: "s3_measure_count",
        path: write(directory, "measure_num.txt", "3\n")
      }
    ]
  end

  def openscore_sources(directory)
    annotations = write(
      directory,
      "annotations.csv",
      "qstamp,measure,beat,measure_fraction,label,part,part_num,instrument\n" \
      "0,1,1,0,a,Flute,0,Flute\n4,2,1,0,a,Violin,1,Violin\n"
    )
    relations = write(
      directory,
      "relations.csv",
      "qstamp_start,qstamp_end,flute1,violin1\n" \
      "0,4,Main Part,U(Main)\n4,12,U(Main),Main Part\n"
    )
    [
      { kind: "hauptstimme_annotations", path: annotations },
      { kind: "part_relations", path: relations }
    ]
  end

  def write(directory, name, content)
    path = File.join(directory, name)
    File.write(path, content)
    path
  end
end
