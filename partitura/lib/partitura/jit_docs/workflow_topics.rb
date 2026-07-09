# frozen_string_literal: true

module Partitura
  module JITDocs
    WORKFLOW_TOPICS = {
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
          "start <dir> [--procedure ID] [--source FILE] [--miniature] begins a run; status re-orients a fresh " \
          "context; commit --notes - advances; next/back/log/abandon manage exceptions.",
          "Pass notes are `field: value` lines, one per schema field (later lines without a key continue the " \
          "previous field). \"none\" is legal for a field with truly nothing to report; absence is not.",
          "weaknesses/outputs/improvements feed forward to later payloads as OPEN THREADS.",
          "Gate glossary: artifact_exists (named file written), pass_note_complete (all schema fields present), " \
          "source_compiles, lint_max (no lints at/above level), export_current (export newer than source), " \
          "min_units (N unit commits before --stage-complete), units_cover_source_bars (every bar had its own " \
          "span pass), no_open_skips / no_stale_stages (skipped or reopened-then-not-recommitted stages block " \
          "closeout).",
          "Iterative stages commit one unit at a time (--span A-B or --unit \"...\") and close with " \
          "--stage-complete; a bare commit is refused."
        ],
        example: <<~TEXT.strip,
            bars: 5-8
            decisions: viola takes the call's tail as a countermelody; cello holds the ground
            weaknesses: bar 7 downbeat is the third homorhythmic attack in a row
            improvements: composed an off-beat entry for the viola at b6.5 (was a stamped pad)
            outputs: countermelody cell (b6) available for the return
            musical_verdict: the span now answers the call instead of accompanying it
          TEXT
        next_topics: %i[production harmony projections marks],
        docs: ["reference/written/procedures/partitura/dsl_composition/principles.md"]
      },
      export: {
        use_when: "Export production DSL source to MusicXML and MIDI.",
        rules: [
          "Exporters consume the compiled model directly; there is no serialized handoff.",
          "The Ruby exporter fills only silent gaps; it does not compose material.",
          "Use `production_export SOURCE.rb --stem STEM` when writing MusicXML and MIDI."
        ],
        example: <<~BASH.strip,
            partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
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
      }
    }.freeze
  end
end
