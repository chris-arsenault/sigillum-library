# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class DiagnosticsTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura/bin/partitura")

  def test_compile_errors_keep_legacy_fields_and_add_one_diagnostic
    error = Partitura::Production::CompileError.new(
      code: "bad_note",
      message: "phrase :opening has a bad note",
      repair_instruction: "Correct the note.",
      help_topic: "absolute",
      docs: ["docs/example.md"],
      extra: { phrase: :opening }
    )

    response = error.response
    assert_equal "bad_note", response.fetch(:code)
    assert_equal :opening, response.fetch(:phrase)
    diagnostic = response.fetch(:diagnostics).fetch(0)
    assert_equal "phrase:opening", diagnostic.fetch(:object_path)
    assert_equal "absolute", diagnostic.fetch(:help_topic)
    assert_equal Partitura::Diagnostic::FIELDS, diagnostic.keys
  end

  def test_workflow_and_evaluation_errors_share_the_envelope
    workflow = Partitura::Production::CompositionWorkflow::Error.new(
      "invalid_workflow_record", "bad workflow", details: { object_path: "stages.s1" }
    ).to_h
    evaluation = Partitura::Production::Evaluation::Error.new(
      "invalid_evaluation_record", "bad evaluation"
    ).to_h

    assert_equal "stages.s1", workflow.dig(:diagnostics, 0, :object_path)
    assert_equal "invalid_evaluation_record", evaluation.dig(:diagnostics, 0, :code)
  end

  def test_diagnostic_envelopes_do_not_freeze_caller_owned_values
    message = +"bad workflow"
    docs = [+"docs/example.md"]
    response = {
      status: "error", code: "bad_record", message: message,
      docs: docs
    }

    Partitura::Diagnostic.envelope(response)

    refute_predicate message, :frozen?
    refute_predicate docs, :frozen?
    refute_predicate docs.fetch(0), :frozen?
  end

  def test_lints_convert_without_changing_the_original_hash
    lint = {
      rule: "phrase_length", level: "warn", phrase: :opening,
      message: "spans too many bars", help_topic: "phrase_placement"
    }

    diagnostic = Partitura::Production::Lint.diagnostics([lint]).fetch(0)

    assert_equal :warn, diagnostic.severity
    assert_equal "phrase:opening", diagnostic.object_path
    assert_equal "warn", lint.fetch(:level)
  end

  def test_missing_compile_source_is_a_structured_failure
    missing = File.join(ROOT, "partitura/test/does-not-exist.rb")
    stdout, stderr, status = Open3.capture3(RbConfig.ruby, CLI, "compile", missing, chdir: ROOT)

    assert_empty stdout
    refute status.success?
    payload = JSON.parse(stderr)
    assert_equal "unreadable_source", payload.fetch("code")
    assert_equal missing, payload.dig("diagnostics", 0, "source_file")
  end

  def test_compile_error_context_regenerates_the_diagnostic
    error = Partitura::Production::CompileError.new(
      code: "bad_note", message: "bad note",
      repair_instruction: "Correct the note.", help_topic: "absolute", docs: []
    )

    contextual = error.with_context(section: :s1).with_context(phrase: :opening)
    diagnostic = contextual.response.fetch(:diagnostics).fetch(0)

    assert_includes contextual.message, "phrase :opening"
    assert_equal "phrase:opening", diagnostic.fetch(:object_path)
    assert_equal :s1, diagnostic.dig(:details, :section)
  end

  def test_missing_view_source_uses_the_same_structured_boundary
    missing = File.join(ROOT, "partitura/test/does-not-exist.rb")
    stdout, stderr, status = Open3.capture3(RbConfig.ruby, CLI, "view", missing, chdir: ROOT)

    assert_empty stdout
    refute status.success?
    payload = JSON.parse(stderr)
    assert_equal "unreadable_source", payload.fetch("code")
    assert_equal missing, payload.dig("diagnostics", 0, "source_file")
  end
end
