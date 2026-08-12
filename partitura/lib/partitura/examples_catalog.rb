# frozen_string_literal: true

module Partitura
  module ExamplesCatalog
    SCHEMA_VERSION = 1
    ENTRIES = [
      {
        id: "production_hybrid", kind: "production", status: "canonical",
        path: "experiments/partitura/production_hybrid_study.rb",
        purpose: "Executable production authoring, projections, compile, and export."
      },
      {
        id: "storyteller_surface", kind: "prototype", status: "historical",
        path: "experiments/partitura/storyteller_surface_study.rb",
        purpose: "Biased note-list-adjacent baseline; not the production API."
      },
      {
        id: "degree_key", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/degree_key_32.rb",
        purpose: "Key-relative scale degree and function representation."
      },
      {
        id: "relative_interval", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/relative_interval_32.rb",
        purpose: "Motivic contour and transformation without absolute pitch."
      },
      {
        id: "split_pitch_rhythm", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/split_pitch_rhythm_32.rb",
        purpose: "Independently inspectable pitch and rhythm streams."
      },
      {
        id: "staff_grid", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/staff_grid_32.rb",
        purpose: "Bar-local simultaneity and vertical checkpoints."
      },
      {
        id: "phrase_placement", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/phrase_placement_32.rb",
        purpose: "Explicit entrances and inspectable phrase realization."
      },
      {
        id: "hybrid_phrase_staff", kind: "surface_lab", status: "exploratory",
        path: "experiments/partitura/surface_lab/hybrid_phrase_staff_32.rb",
        purpose: "Phrase continuity combined with staff checkpoints."
      },
      {
        id: "composition_workflow", kind: "test_fixture", status: "contract_fixture",
        path: "partitura/test/fixtures/composition_workflow_study.rb",
        purpose: "Graph scheduling, isolated patches, promotion, trajectory, and review contract."
      }
    ].map(&:freeze).freeze

    module_function

    def data(id = nil)
      return { schema_version: SCHEMA_VERSION, examples: ENTRIES } unless id

      entry = ENTRIES.find { |candidate| candidate.fetch(:id) == id.to_s }
      raise KeyError, "unknown example #{id.inspect}" unless entry

      { schema_version: SCHEMA_VERSION, example: entry }
    end
  end
end
