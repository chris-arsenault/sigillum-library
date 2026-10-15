# frozen_string_literal: true

require "tmpdir"
require_relative "../lib/partitura"
require_relative "../lib/partitura/composer"

module ComposerFixture
  def setup
    @root = Dir.mktmpdir("partitura-composer-")
    @service = Partitura::Composer::Service.new(root: @root)
    @revision = @service.start(
      "id" => "study", "title" => "Study", "brief" => "A connected clarinet line over cello.",
      "parts" => [{ "id" => "cl", "name" => "Clarinet", "instrument" => "Clarinet" },
                  { "id" => "vc", "name" => "Cello", "instrument" => "Violoncello" }]
    ).fetch(:revision)
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def write(*changes, preview: false, **single_change)
    changes << single_change unless single_change.empty?
    result = @service.revise("piece" => "study", "revision" => @revision, "changes" => changes, "preview" => preview)
    @revision = result.fetch(:revision)
    result
  end

  def section(id = "opening", bars: 2, **context)
    { "type" => "set_section", "section" => { "id" => id, "name" => id.capitalize, "bars" => bars,
                                               **context.transform_keys(&:to_s) } }
  end

  def passage(section = "opening", events: "C5:2{slur(} E5:2 | D5:2 G4:2{slur)}", bass: "C3:4 | G2:4")
    { "type" => "write_passage", "section" => section, "passage" => {
      "id" => "call", "at" => 1, "bars" => 2, "chords" => "b1:C b2:G7", "purpose" => "A single question.",
      "voices" => [{ "id" => "lead", "part" => "cl", "events" => events },
                    { "id" => "bass", "part" => "vc", "role" => "bass", "events" => bass }]
    } }
  end

  def piece
    Partitura.load_production_file(@service.store.path("study"))
  end
end
