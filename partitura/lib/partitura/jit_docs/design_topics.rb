# frozen_string_literal: true

module Partitura
  module JITDocs
    DESIGN_TOPICS = {
      index: {
        use_when: "Start here for any Partitura task or when unsure which focused topic to request.",
        rules: [
          "Load only the relevant topic docs, not the whole documentation set.",
          "Use `llm_design` to understand the inference-time capability and context architecture.",
          "Use the production surface for new DSL source; surface_lab is exploratory only.",
          "Standardize the container; choose the local surface by musical job.",
          "Use `guided` for stage-at-a-time procedures and `composition_workflow` for external proposals.",
          "Use `score_observation` or `annotation_observation` for accepted external scores."
        ],
        example: "partitura/bin/partitura help production",
        next_topics: %i[llm_design production decision guided composition_graph composition_workflow evaluation
                        score_observation annotation_observation projections export],
        docs: ["docs/architecture/partitura/INDEX.md"]
      },
      llm_design: {
        use_when: "Explain or evaluate how Partitura extends LLM capability without fine-tuning.",
        rules: [
          "Partitura supplies domain capability at inference time; it does not change model weights.",
          "The bare CLI and JIT topic graph route an agent to the smallest relevant context.",
          "Markdown carries depth, while typed DSL objects, closed vocabularies, and versioned " \
          "schemas enforce structure.",
          "Focused projections provide non-linear reads over one canonical source instead of " \
          "editable duplicate summaries.",
          "Guided state, stable graph paths, schema versions, and content digests preserve " \
          "specificity across contexts.",
          "Mechanical validation prevents representational errors; it does not prove musical " \
          "quality or expertise."
        ],
        example: <<~TEXT.strip,
            partitura/bin/partitura help index
            partitura/bin/partitura help decision
            partitura/bin/partitura view SOURCE.rb verticals --bars 9-12
            partitura/bin/partitura status <piece_dir>
          TEXT
        next_topics: %i[production guided composition_graph composition_workflow score_observation compile_api],
        docs: ["docs/architecture/partitura/LLM_CONTEXT_ARCHITECTURE.md"]
      }
    }.freeze
  end
end
