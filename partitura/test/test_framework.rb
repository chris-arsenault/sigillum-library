# frozen_string_literal: true

require "fileutils"
require "json"
require "minitest/autorun"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura/framework"

class FrameworkTest < Minitest::Test
  def test_registry_builds_selected_movement_exports
    movement_output_dir = Partitura::Framework::Paths::MOVEMENT_OUTPUTS.join("mvt1_registry")
    FileUtils.rm_rf(movement_output_dir)

    Dir.mktmpdir do |dir|
      source = File.join(dir, "movement.rb")
      registry = File.join(dir, "registry.rb")
      File.write(source, simple_source("Registry Movement"))
      File.write(registry, <<~RUBY)
        movement :mvt1,
          title: "Registry Movement",
          source: "movement.rb",
          output_stem: "mvt1_registry",
          bars: 1..1,
          roman: "I",
          status: :draft
      RUBY

      exports = Partitura::Framework::Registry.load_file(registry).export(:mvt1)

      assert File.exist?(exports.first.fetch(:musicxml))
      assert File.exist?(exports.first.fetch(:midi))
      assert_includes File.read(exports.first.fetch(:musicxml)), "Registry Movement"
    end
  ensure
    FileUtils.rm_rf(movement_output_dir)
  end

  def test_registry_rejects_unknown_movement_selection
    registry = Partitura::Framework::Registry.new
    registry.register(
      id: :mvt1,
      title: "One",
      source: "one.rb",
      output_stem: "one",
      bars: 1..1,
      roman: "I",
      status: :draft
    )

    error = assert_raises(KeyError) { registry.export(:missing) }
    assert_includes error.message, "unknown movement: missing"
  end

  def test_movement_spec_resolves_relative_and_absolute_sources
    spec = Partitura::Framework::MovementSpec.new(id: :mvt1, title: "One", source: "movement.rb")
    assert_equal Pathname.new("/tmp/project/movement.rb"), spec.source_path(base_dir: "/tmp/project")

    absolute = Partitura::Framework::MovementSpec.new(id: :mvt2, title: "Two", source: "/tmp/source.rb")
    assert_equal Pathname.new("/tmp/source.rb"), absolute.source_path(base_dir: "/ignored")
  end

  def test_export_raises_structured_compile_error_for_invalid_piece
    bad_piece = Partitura::Production.piece("Bad export") do
      control { dynamic :mf, at: "bar 1 beat 1", for: :all }
    end

    error = assert_raises(Partitura::Production::CompileError) do
      Partitura.production_musicxml(bad_piece)
    end

    assert_equal "unknown_control_target", error.response.fetch(:code)
    assert_includes error.response.fetch(:repair_instruction), "existing part"
  end

  def test_dynamic_tempo_audit_reads_model_facts
    piece = dynamic_tempo_audit_piece

    findings = Partitura::Framework::Audit.dynamic_tempo(piece)
    formatted = Partitura::Framework::Audit.format_dynamic_tempo(findings)

    assert_equal 1, findings.fetch("hist").fetch("mp")
    assert_equal 1, findings.fetch("decels").length
    assert_equal 1, findings.fetch("atempos").length
    assert_empty findings.fetch("unresolved_tempo")
    refute(findings.fetch("missing_entrances").any? { |entry| entry.fetch("part") == "cello" })
    assert(findings.fetch("missing_entrances").any? { |entry| entry.fetch("part") == "flute" })
    assert_includes formatted, "## Dynamics + tempo audit (Ruby model-measured)"
  end

  private

  def dynamic_tempo_audit_piece
    Partitura::Production.piece("Audit") do
      meter "4/4"; key "C"
      roster {
 part :cello, "Cello", music21: "Violoncello", family: :string;
 part :flute, "Flute", music21: "Flute", family: :woodwind }
      tempo { ritardando from: "bar 1 beat 3", to: "bar 2 beat 1"; a_tempo at: "bar 2 beat 2" }
      control { dynamic :mp, at: "bar 1 beat 1", for: :string }
      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:cello_line, surface: :absolute) { events "C3:1 r:1 D3:2" }
          phrase(:flute_line, surface: :absolute) { events "G4:4" }
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :bass
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def simple_source(title)
    <<~RUBY
      production_piece #{title.inspect} do
        meter "4/4"
        key "C"

        roster do
          part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
        end

        section :s1, "Opening", bars: 1..1 do
          span bars: 1..1 do
            phrase(:line, surface: :absolute) { events "C5:4{mf}" }
            placement :line, part: :clarinet, at: "bar 1 beat 1", role: :foreground
          end
        end
      end
    RUBY
  end
end
