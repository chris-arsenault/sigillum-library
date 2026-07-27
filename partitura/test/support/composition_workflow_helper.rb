# frozen_string_literal: true

require "open3"
require "tmpdir"

module CompositionWorkflowTestSupport
  Workflow = Partitura::Production::CompositionWorkflow
  WORKFLOW_FIXTURE = File.expand_path(
    "../fixtures/composition_workflow_study.rb", __dir__
  )

  def with_source
    Dir.mktmpdir("partitura-composition-workflow-") do |directory|
      source = File.join(directory, "study.rb")
      FileUtils.cp(WORKFLOW_FIXTURE, source)
      yield source, directory
    end
  end

  def scheduled_action(snapshot)
    state = Workflow::State.new(snapshot: snapshot)
    Workflow::DeterministicScheduler.new.next_action(state).action
  end

  def inline_candidate(action, patch: bass_patch("study.rb"), description: "Complete the bass.")
    Workflow::Candidate.inline(
      action,
      source_patch: patch,
      description: description
    )
  end

  def bass_patch(source_name)
    replacement_patch(
      source_name,
      ['        pitch_bars "C3 G2"', '        rhythm_bars "2 2"'],
      ['        pitch_bars "C3 G2 | B2 G2"', '        rhythm_bars "2 2 | 2 2"']
    )
  end

  def invalid_patch(source_name)
    replacement_patch(
      source_name,
      ['        pitch_bars "C3 G2"'],
      ['        pitch_bars "C3 G2']
    )
  end

  def replacement_patch(source_name, before, after)
    lines = File.readlines(WORKFLOW_FIXTURE)
    line = lines.index { |item| item.chomp == before.first } + 1
    previous = lines.fetch(line - 2).chomp
    following = lines.fetch(line - 1 + before.length).chomp
    body = patch_body(previous, before, after, following)
    patch_header(source_name, line, before.length, after.length) + body + "\n"
  end

  def patch_body(previous, before, after, following)
    ([" #{previous}"] + before.map { |item| "-#{item}" } +
      after.map { |item| "+#{item}" } + [" #{following}"]).join("\n")
  end

  def patch_header(source_name, line, old_length, new_length)
    <<~PATCH
      diff --git a/#{source_name} b/#{source_name}
      --- a/#{source_name}
      +++ b/#{source_name}
      @@ -#{line - 1},#{old_length + 2} +#{line - 1},#{new_length + 2} @@
    PATCH
  end

  def run_cli(*arguments)
    Open3.capture3(
      "ruby",
      File.expand_path("../../bin/partitura", __dir__),
      *arguments
    )
  end
end
