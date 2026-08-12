# frozen_string_literal: true

module Partitura
  module JITDocs
    WORKFLOW_TOPICS = {
      composition_graph: {
        use_when: "Plan or recursively refine a whole score, or expose stable scopes to an external consumer.",
        rules: [
          "The production Ruby source remains authoritative; the Composition Graph is a derived projection.",
          "Graph-aware source declares stable piece, span, and placement IDs.",
          "Declare recurring non-sounding identity with `material`; exact sounding notes remain in phrases.",
          "Use scoped `plan { requires ... }` blocks; open and partial requirements are valid during composition.",
          "The closed requirement facets are harmony, material, role, part, texture, control, and checkpoint.",
          "The authored relations are derives_from, returns_to, and depends_on; contains and realizes are derived.",
          "Use `composition_graph` and `composition_resolution` to inspect plans; use " \
          "`composition_snapshot --json` for external analysis.",
          "A bound requirement proves authored coverage only, never musical quality."
        ],
        example: <<~RUBY.strip,
            production_piece "Study", id: :study do
              material(:theme_a) { identity pitch: "rising fourth", rhythm: "short short long" }
              roster { part :clarinet, "Clarinet", music21: "Clarinet" }

              section :opening, "Statement", bars: 1..2 do
                span :opening_call, bars: 1..2 do
                  plan do
                    requires :material, :theme_a, relation: :statement
                    requires :role, :foreground
                  end
                  phrase :theme_a_call, surface: :absolute,
                          material: :theme_a, relation: :statement do
                    events "C5:2 F5:2 | E5:4"
                  end
                  placement :theme_a_call, id: :theme_a_call_clarinet,
                            part: :clarinet, role: :foreground, at: "bar 1 beat 1"
                end
              end
            end
          RUBY
        next_topics: %i[container phrase_placement projections guided composition_workflow],
        docs: ["docs/architecture/partitura/09_composition_graph.md"]
      },
      harmony: {
        use_when: "Declare the span's per-bar chord track, or check declared harmony against the sounding notes.",
        rules: [
          "Declare per-bar chords on the span: chords \"b1:F b2:Bb b3-4:C7\" (bars must sit inside the span).",
          "Symbols are letter chords: root, optional #/b, quality (m 7 m7 maj7 dim dim7 aug m7b5 6 m6 sus4 sus2), " \
          "optional /bass.",
          "The chord track is the machine-comparable harmony declaration: `harmony_check` diffs it against the " \
          "sounding implied_harmony per bar.",
          "Free prose stays commentary via `harmony \"...\"`; a harmony string entirely in bN:Chord form routes " \
          "to the chord track automatically.",
          "Chords-first composing: declare the track, write voices against it, close the loop with harmony_check.",
          "A deliberately linear/contrapuntal bar may legitimately stay MISMATCH - say so by bar in your audit."
        ],
        example: <<~RUBY.strip,
            span bars: 17..20 do
              chords "b17:Am b18:E7 b19-20:Dm"
              harmony "the E7 is an arrival, not a passing sonority"
            end
          RUBY
        next_topics: %i[degrees projections controls container],
        docs: ["docs/architecture/partitura/01_container.md"]
      },
      guided: {
        use_when: "Run or resume a guided procedure (composition or recomposition) stage by stage.",
        rules: [
          "The default composition run starts with `start <dir> --source FILE --brief TEXT`; " \
          "section_recomposition does not require a brief.",
          "`status [<dir>]` re-orients a fresh context; commit advances; next/back/log/abandon manage exceptions.",
          "Pass notes are `field: value` lines, one per schema field (later lines without a key continue the " \
          "previous field). \"none\" is legal for a field with truly nothing to report; absence is not.",
          "Required fields are decisions, carries, improvements, and musical_verdict.",
          "Use the optional `graph_paths:` field to reference exact Composition Graph scopes without copying " \
          "realized music into the pass note.",
          "Only carries feed forward as OPEN THREADS; realized music stays in source, and fixable " \
          "weaknesses are fixed now.",
          "Gate glossary: artifact_exists (named file written), pass_note_complete (all schema fields present), " \
          "source_compiles, composition_graph_valid/bound, lint_max (no lints at/above level), " \
          "export_current (export newer than source), " \
          "min_units (N unit commits before --stage-complete), units_cover_source_bars (every bar had its own " \
          "span pass), no_open_skips / no_stale_stages (skipped or reopened-then-not-recommitted stages block " \
          "closeout).",
          "Iterative stages commit one unit at a time (--span A-B or --unit \"...\") and close with " \
          "--stage-complete; a bare commit is refused."
        ],
        example: <<~TEXT.strip,
            decisions: viola takes the call's tail as a countermelody; cello holds the ground
            carries: the return still needs a registral destination in the final section
            improvements: composed an off-beat entry for the viola at b6.5 (was a stamped pad)
            musical_verdict: the span now answers the call instead of accompanying it
            graph_paths: span:development_5_8, material:call_tail
          TEXT
        next_topics: %i[production composition_graph harmony projections marks],
        docs: [
          "docs/architecture/partitura/08_cli_and_guided_runs.md",
          "reference/written/procedures/partitura/dsl_composition/principles.md"
        ]
      },
      composition_workflow: {
        use_when: "Exchange graph-addressed proposals, assessments, and selections with an external system.",
        rules: [
          "The accepted Ruby source and Ruby-owned Composition Graph remain authoritative.",
          "`observe` emits one schema-v1 proposal_request bound to exact source, graph, snapshot, " \
          "action, and trajectory state.",
          "`evaluate` applies explicit patches only to isolated sources, compiles them, and emits " \
          "immutable candidate evidence.",
          "`step` revalidates live bindings, promotes exact validated bytes or retains original, " \
          "and appends one schema-v2 transition.",
          "External producers and selectors return versioned responses; they do not parse, promote, " \
          "or rewrite accepted state directly.",
          "Use `--trajectory-origin agent` for agent runs; Partitura enforces the medium provenance label.",
          "`--no-export` is for fast mechanical experiments; normal selection evidence includes " \
          "exported candidate observations."
        ],
        example: <<~'BASH'.strip,
            partitura/bin/partitura observe SOURCE.rb --trajectory TRAJECTORY.jsonl
            partitura/bin/partitura evaluate SOURCE.rb --trajectory TRAJECTORY.jsonl --proposals PROPOSAL.json
            partitura/bin/partitura step SOURCE.rb --trajectory TRAJECTORY.jsonl \
              --proposals PROPOSAL.json --selection SELECTION.json
          BASH
        next_topics: %i[composition_graph evaluation score_observation compile_api],
        docs: [
          "docs/architecture/partitura/08_cli_and_guided_runs.md",
          "docs/architecture/partitura/09_composition_graph.md"
        ]
      },
      evaluation: {
        use_when: "Create blinded comparisons or record criterion-specific preferences for " \
                  "transitions or completed scores.",
        rules: [
          "Transition review replays stored trajectory evidence; completed-score review compares " \
          "two explicit source files.",
          "Public A/B bundles contain MusicXML/MIDI and criterion, but omit candidate or system-run mappings.",
          "Private append-only records retain the blind mapping and exact evidence identity.",
          "Transition review separates scale (local/seam/section/global/export) from criterion " \
          "(coherence/identity/seams/orchestration/reserve).",
          "Preference records carry an explicit purpose so consumers cannot silently mix evaluation sets.",
          "Completed-score measurements are descriptive diagnostics, not musical-quality scores."
        ],
        example: <<~'BASH'.strip,
            partitura/bin/partitura benchmark-score SOURCE.rb
            partitura/bin/partitura benchmark-review LEFT.rb RIGHT.rb \
              --left-run RUN_A --right-run RUN_B --benchmark BENCHMARK --case CASE \
              --criterion coherence --reviews REVIEWS.jsonl --output BUNDLES
          BASH
        next_topics: %i[composition_workflow composition_graph score_observation],
        docs: [
          "docs/architecture/partitura/08_cli_and_guided_runs.md",
          "docs/architecture/partitura/09_composition_graph.md"
        ]
      },
      export: {
        use_when: "Export production DSL source to MusicXML and MIDI.",
        rules: [
          "Exporters consume the compiled model directly; there is no serialized handoff.",
          "The Ruby exporter fills only silent gaps; it does not compose material.",
          "Use `partitura/bin/partitura export SOURCE.rb --stem STEM` when writing MusicXML and MIDI.",
          "Export writes under the source repository's outputs/<source-relative-directory>/<stem>/ directory."
        ],
        example: <<~'BASH'.strip,
            partitura/bin/partitura export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
          BASH
        next_topics: %i[compile_api projections],
        docs: ["docs/architecture/partitura/05_compile_api.md"]
      },
      compile_api: {
        use_when: "Consume production authoring compile responses and error repairs.",
        rules: [
          "Every compiler response must name relevant next help topics.",
          "Every error includes a repair instruction and focused docs.",
          "Compiler checks stay mechanical, not musical-quality judgments.",
          "Responses are structured for LLM action, not human explanation."
        ],
        example: <<~JSON.strip,
            {
              "status": "error",
              "code": "surface_event_count_mismatch",
              "repair_instruction": "Make the two streams align event-by-event.",
              "help_topic": "split_pitch_rhythm"
            }
          JSON
        next_topics: %i[index decision projections export],
        docs: ["docs/architecture/partitura/05_compile_api.md"]
      },
      score_observation: {
        use_when: "Validate external MusicXML or MXL and project sounding score facts for analysis.",
        rules: [
          "Use `score-observation` for accepted external scores; do not convert them into DSL source first.",
          "The projection is versioned, deterministic, read-only, and content-addressed.",
          "Partitura resolves MXL, polyphony, voices, staves, transposition, ties, rests, and rational timing.",
          "The projection reports score facts, not inferred form, orchestral quality, or consumer judgments.",
          "Keep source selection, derived interpretations, and downstream evaluation outside Partitura."
        ],
        example: "partitura/bin/partitura score-observation path/to/score.mxl",
        next_topics: %i[annotation_observation composition_graph projections compile_api],
        docs: ["docs/architecture/partitura/10_score_observation.md"]
      },
      annotation_observation: {
        use_when: "Bind a supported external annotation source to an exact score-observation digest.",
        rules: [
          "Start from an immutable score-observation JSON document, not raw MusicXML alone.",
          "Choose a named, versioned profile and supply each annotation as KIND=FILE.",
          "Profiles preserve source labels, source-row provenance, canonical score addresses, " \
          "alignment warnings, and factual span features.",
          "A well-formed semantic row that cannot bind fails instead of disappearing silently; " \
          "excluded source defects remain row-addressed warnings.",
          "Annotation observations do not create quality judgments or consumer-specific derived representations."
        ],
        example: <<~'BASH'.strip,
            partitura/bin/partitura annotation-observation score-observation.json \
              --profile openscore_hauptstimme_v1 \
              --annotation hauptstimme_annotations=annotations.csv \
              --annotation part_relations=part_relations.csv
          BASH
        next_topics: %i[score_observation evaluation composition_graph],
        docs: ["docs/architecture/partitura/11_annotation_observation.md"]
      }
    }.freeze
  end
end
