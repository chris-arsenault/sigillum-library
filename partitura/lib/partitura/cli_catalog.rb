# frozen_string_literal: true

module Partitura
  module CLICatalog
    SCHEMA_VERSION = 1

    def self.deep_freeze(value)
      case value
      when Hash
        value.each { |key, item| deep_freeze(key); deep_freeze(item) }
      when Array
        value.each { |item| deep_freeze(item) }
      end
      value.freeze
    end

    def self.command(category:, summary:, usage:, effect:, output:, help_topic:, arguments: [], options: [])
      deep_freeze(
        category: category.to_s,
        summary:,
        usage:,
        effect: effect.to_s,
        output: output.to_s,
        help_topic: help_topic.to_s,
        arguments:,
        options:
      )
    end

    COMMANDS = {
      "commands" => command(
        category: :discover, summary: "Describe all CLI commands or one command as typed data.",
        usage: "commands [COMMAND] [--json]", effect: :read,
        output: :command_catalog, help_topic: :index,
        arguments: [{ name: "command", type: "command", required: false }],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "catalog" => command(
        category: :discover, summary: "List runtime catalogues or inspect one catalogue item.",
        usage: "catalog [NAME [ITEM]] [--json]", effect: :read,
        output: :runtime_catalog, help_topic: :index,
        arguments: [
          { name: "name", type: "catalog", required: false },
          { name: "item", type: "catalog_item", required: false }
        ],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "protocol" => command(
        category: :discover,
        summary: "Create request-bound workflow responses or validate protocol messages.",
        usage: "protocol template proposal-response|selection-response REQUEST.json [OPTIONS] | " \
               "protocol validate MESSAGE.json [--against REQUEST.json]",
        effect: :read, output: :protocol_message_or_validation,
        help_topic: :protocol,
        arguments: [
          { name: "action", type: "enum", required: true, values: %w[template validate] },
          { name: "kind", type: "protocol_template_kind", required: "for_template" },
          { name: "message", type: "json_path", required: true }
        ],
        options: [
          { flag: "--producer", type: "producer_id", required: "for_template" },
          { flag: "--patch", type: "path_or_stdin", applies_to: "proposal_response" },
          { flag: "--description", type: "text", applies_to: "proposal_response" },
          { flag: "--candidate-id", type: "candidate_id", applies_to: "proposal_response" },
          { flag: "--select", type: "candidate_id_or_original", applies_to: "selection_response" },
          { flag: "--reason", type: "text", applies_to: "selection_response" },
          { flag: "--against", type: "json_path", required: "for_response_validation" }
        ]
      ),
      "help" => command(
        category: :author, summary: "Return one focused JIT documentation topic.",
        usage: "help [TOPIC] [--json]", effect: :read, output: :jit_document,
        help_topic: :index,
        arguments: [{ name: "topic", type: "topic", required: false }],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "import-musicxml" => command(
        category: :author,
        summary: "Convert an authoritative hand-edited MusicXML range into paste-ready DSL event bodies.",
        usage: "import-musicxml SCORE.musicxml [--bars A-B] [--segments SPEC] [--beats N] " \
               "[--perc-map FROM=TO] [--json]",
        effect: :read, output: :musicxml_import_conversion,
        help_topic: :hand_edit_import,
        arguments: [{ name: "score", type: "musicxml_path", required: true }],
        options: [
          { flag: "--bars", type: "bar_range", default: "1-10000" },
          { flag: "--segments", type: "named_bar_ranges" },
          { flag: "--beats", type: "positive_rational", default: "2" },
          { flag: "--perc-map", type: "pitch_mapping", repeatable: true },
          { flag: "--json", type: "boolean" }
        ]
      ),
      "verify-musicxml-import" => command(
        category: :author,
        summary: "Compare an imported range with the current export at sounding pitch.",
        usage: "verify-musicxml-import HAND.musicxml EXPORT.musicxml [--bars A-B] [--beats N] " \
               "[--perc-map FROM=TO] [--json]",
        effect: :read, output: :musicxml_import_verification,
        help_topic: :hand_edit_import,
        arguments: [
          { name: "hand", type: "musicxml_path", required: true },
          { name: "export", type: "musicxml_path", required: true }
        ],
        options: [
          { flag: "--bars", type: "bar_range", default: "1-10000" },
          { flag: "--beats", type: "positive_rational", default: "2" },
          { flag: "--perc-map", type: "pitch_mapping", repeatable: true },
          { flag: "--json", type: "boolean" }
        ]
      ),
      "compile" => command(
        category: :author, summary: "Compile and mechanically validate production source.",
        usage: "compile SOURCE.rb", effect: :read, output: :compile_response,
        help_topic: :compile_api,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }]
      ),
      "lint" => command(
        category: :author, summary: "Render configurable production-source lint findings.",
        usage: "lint SOURCE.rb", effect: :read, output: :lint_report,
        help_topic: :production,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }]
      ),
      "view" => command(
        category: :author, summary: "List projections or render one focused source projection.",
        usage: "view [SOURCE.rb [VIEW]] [--part ID] [--bars A-B] [--json]",
        effect: :read, output: :projection_or_catalog, help_topic: :projections,
        arguments: [
          { name: "source", type: "ruby_source_path", required: false },
          { name: "view", type: "view", required: false, default: "structure" }
        ],
        options: [
          { flag: "--part", type: "part_id" },
          { flag: "--bars", type: "bar_range" },
          { flag: "--json", type: "boolean" }
        ]
      ),
      "cards" => command(
        category: :library, summary: "Search, show, or enumerate production-DSL technique cards.",
        usage: "cards <TERMS...> | cards show ID | cards terms", effect: :read,
        output: :card_results, help_topic: :cards,
        arguments: [{ name: "query", type: "card_query", required: true, variadic: true }]
      ),
      "export" => command(
        category: :output, summary: "Export production source to MusicXML and MIDI.",
        usage: "export SOURCE.rb [--stem STEM]", effect: :write_outputs,
        output: :export_paths, help_topic: :export,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }],
        options: [{ flag: "--stem", type: "output_stem" }]
      ),
      "build" => command(
        category: :output, summary: "Build one or all entries from a framework registry.",
        usage: "build REGISTRY.rb [ENTRY|all]", effect: :write_outputs,
        output: :export_paths, help_topic: :build,
        arguments: [
          { name: "registry", type: "ruby_registry_path", required: true },
          { name: "entry", type: "registry_entry", required: false, default: "all" }
        ]
      ),
      "start" => command(
        category: :compose, summary: "Initialize a guided composition or recomposition run.",
        usage: "start DIR [--procedure ID] [--source FILE] [--brief TEXT] [--miniature] [--force-new]",
        effect: :write_run_state, output: :guided_stage, help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: true }],
        options: [
          { flag: "--procedure", type: "procedure_id", default: "dsl_composition" },
          { flag: "--source", type: "ruby_source_path" },
          { flag: "--brief", type: "text" },
          { flag: "--miniature", type: "boolean" },
          { flag: "--force-new", type: "boolean" }
        ]
      ),
      "status" => command(
        category: :compose, summary: "Resume exact guided-run state and return its current stage.",
        usage: "status [DIR] [--json]", effect: :read, output: :guided_stage,
        help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "commit" => command(
        category: :compose, summary: "Record pass notes, run gates, and advance guided state.",
        usage: "commit [DIR] [--span A-B | --unit LABEL] [--stage-complete] --notes FILE|-",
        effect: :write_run_state, output: :guided_stage, help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [
          { flag: "--notes", type: "path_or_stdin", required: true },
          { flag: "--span", type: "bar_range", conflicts_with: ["--unit"] },
          { flag: "--unit", type: "text", conflicts_with: ["--span"] },
          { flag: "--stage-complete", type: "boolean" },
          { flag: "--source", type: "ruby_source_path" }
        ]
      ),
      "next" => command(
        category: :compose, summary: "Skip the current guided stage with a blocking audit record.",
        usage: "next [DIR] --reason TEXT", effect: :write_run_state,
        output: :guided_stage, help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [{ flag: "--reason", type: "text", required: true }]
      ),
      "back" => command(
        category: :compose, summary: "Reopen an earlier guided stage with a reason.",
        usage: "back [DIR] --to STAGE --reason TEXT", effect: :write_run_state,
        output: :guided_stage, help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [
          { flag: "--to", type: "stage_id", required: true },
          { flag: "--reason", type: "text", required: true }
        ]
      ),
      "log" => command(
        category: :compose, summary: "Read a guided run's append-only transition log.",
        usage: "log [DIR] [--json]", effect: :read, output: :guided_log,
        help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "abandon" => command(
        category: :compose, summary: "Close a guided run as abandoned with a reason.",
        usage: "abandon [DIR] --reason TEXT", effect: :write_run_state,
        output: :guided_run_path, help_topic: :guided,
        arguments: [{ name: "directory", type: "piece_directory", required: false }],
        options: [{ flag: "--reason", type: "text", required: true }]
      ),
      "runs" => command(
        category: :compose, summary: "List guided runs under a project root.",
        usage: "runs [ROOT]", effect: :read, output: :guided_run_list,
        help_topic: :guided,
        arguments: [{ name: "root", type: "directory", required: false }]
      ),
      "observe" => command(
        category: :compose, summary: "Emit a request for one graph-addressed proposal action.",
        usage: "observe SOURCE.rb --trajectory FILE", effect: :read,
        output: :proposal_request, help_topic: :composition_workflow,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }],
        options: [
          { flag: "--trajectory", type: "jsonl_path", required: true },
          { flag: "--trajectory-origin", type: "enum", values: %w[deterministic agent] },
          { flag: "--trajectory-quality", type: "enum", values: %w[unrated medium] },
          { flag: "--run-id", type: "run_id" }
        ]
      ),
      "evaluate" => command(
        category: :compose, summary: "Validate proposal patches in isolated candidate sources.",
        usage: "evaluate SOURCE.rb --trajectory FILE --proposals FILE|- [--no-export]",
        effect: :write_candidate_outputs, output: :selection_request,
        help_topic: :composition_workflow,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }],
        options: [
          { flag: "--trajectory", type: "jsonl_path", required: true },
          { flag: "--proposals", type: "path_or_stdin", required: true },
          { flag: "--trajectory-origin", type: "enum", values: %w[deterministic agent] },
          { flag: "--trajectory-quality", type: "enum", values: %w[unrated medium] },
          { flag: "--run-id", type: "run_id" },
          { flag: "--no-export", type: "boolean" }
        ]
      ),
      "step" => command(
        category: :compose, summary: "Revalidate and promote a selected candidate or retain the original.",
        usage: "step SOURCE.rb --trajectory FILE --proposals FILE [--selection FILE] [--no-export]",
        effect: :mutate_source_and_trajectory, output: :workflow_transition,
        help_topic: :composition_workflow,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }],
        options: [
          { flag: "--trajectory", type: "jsonl_path", required: true },
          { flag: "--proposals", type: "json_path", required: true },
          { flag: "--selection", type: "json_path", required: "when_candidates_exist" },
          { flag: "--trajectory-origin", type: "enum", values: %w[deterministic agent] },
          { flag: "--trajectory-quality", type: "enum", values: %w[unrated medium] },
          { flag: "--run-id", type: "run_id" },
          { flag: "--no-export", type: "boolean" }
        ]
      ),
      "review" => command(
        category: :compose, summary: "Create a blinded A/B bundle from stored transition evidence.",
        usage: "review --trajectory FILE --reviews FILE --output DIR --transition ID --candidate ID " \
               "--against original|ID --scale SCALE --criterion CRITERION",
        effect: :write_review_bundle, output: :review_record,
        help_topic: :evaluation,
        options: [
          { flag: "--trajectory", type: "jsonl_path", required: true },
          { flag: "--reviews", type: "jsonl_path", required: true },
          { flag: "--output", type: "directory", required: true },
          { flag: "--transition", type: "transition_id", required: true },
          { flag: "--candidate", type: "candidate_id", required: true },
          { flag: "--against", type: "candidate_id_or_original", required: true },
          { flag: "--scale", type: "enum", required: true,
            values: %w[local seam section global export] },
          { flag: "--criterion", type: "enum", required: true,
            values: %w[coherence identity seams orchestration reserve] },
          { flag: "--seed", type: "text", default: "default" }
        ]
      ),
      "preference" => command(
        category: :compose, summary: "Store one blinded transition preference.",
        usage: "preference --reviews FILE --preferences FILE --review ID --outcome OUTCOME --rater ID " \
               "--purpose LABEL --reason TEXT",
        effect: :append_preference, output: :preference_record,
        help_topic: :evaluation,
        options: [
          { flag: "--reviews", type: "jsonl_path", required: true },
          { flag: "--preferences", type: "jsonl_path", required: true },
          { flag: "--review", type: "review_id", required: true },
          { flag: "--outcome", type: "enum", required: true, values: %w[a b tie abstain] },
          { flag: "--rater", type: "rater_id", required: true },
          { flag: "--purpose", type: "purpose_label", required: true },
          { flag: "--reason", type: "text", required: true },
          { flag: "--confidence", type: "number" }
        ]
      ),
      "benchmark-score" => command(
        category: :evaluate, summary: "Measure one completed score without assigning musical quality.",
        usage: "benchmark-score SOURCE.rb", effect: :read,
        output: :score_measurement, help_topic: :evaluation,
        arguments: [{ name: "source", type: "ruby_source_path", required: true }]
      ),
      "benchmark-review" => command(
        category: :evaluate, summary: "Create a blinded completed-score comparison bundle.",
        usage: "benchmark-review LEFT.rb RIGHT.rb [OPTIONS]", effect: :write_review_bundle,
        output: :score_review_record, help_topic: :evaluation,
        arguments: [
          { name: "left_source", type: "ruby_source_path", required: true },
          { name: "right_source", type: "ruby_source_path", required: true }
        ],
        options: [
          { flag: "--left-run", type: "run_id", required: true },
          { flag: "--right-run", type: "run_id", required: true },
          { flag: "--benchmark", type: "benchmark_id", required: true },
          { flag: "--case", type: "case_id", required: true },
          { flag: "--criterion", type: "enum", required: true,
            values: %w[coherence identity seams orchestration reserve overall] },
          { flag: "--reviews", type: "jsonl_path", required: true },
          { flag: "--output", type: "directory", required: true },
          { flag: "--seed", type: "text", default: "default" }
        ]
      ),
      "benchmark-preference" => command(
        category: :evaluate, summary: "Store one blinded completed-score preference.",
        usage: "benchmark-preference [OPTIONS]", effect: :append_preference,
        output: :score_preference_record, help_topic: :evaluation,
        options: [
          { flag: "--reviews", type: "jsonl_path", required: true },
          { flag: "--preferences", type: "jsonl_path", required: true },
          { flag: "--review", type: "review_id", required: true },
          { flag: "--outcome", type: "enum", required: true, values: %w[a b tie abstain] },
          { flag: "--rater", type: "rater_id", required: true },
          { flag: "--reason", type: "text", required: true },
          { flag: "--confidence", type: "number" }
        ]
      ),
      "score-observation" => command(
        category: :evaluate, summary: "Emit content-addressed facts from external MusicXML or MXL.",
        usage: "score-observation SCORE.musicxml|SCORE.mxl", effect: :read,
        output: :score_observation, help_topic: :score_observation,
        arguments: [{ name: "score", type: "musicxml_or_mxl_path", required: true }]
      ),
      "annotation-observation" => command(
        category: :evaluate, summary: "Bind supported annotations to an exact score observation.",
        usage: "annotation-observation SCORE.json --profile PROFILE --annotation KIND=FILE...",
        effect: :read, output: :annotation_observation,
        help_topic: :annotation_observation,
        arguments: [{ name: "score_observation", type: "json_path", required: true }],
        options: [
          { flag: "--profile", type: "annotation_profile", required: true },
          { flag: "--annotation", type: "annotation_binding", required: true, repeatable: true }
        ]
      )
    }.freeze

    module_function

    def data(name = nil)
      return all_data unless name

      key = name.to_s
      spec = COMMANDS[key]
      raise KeyError, "unknown command #{key.inspect}" unless spec

      { schema_version: SCHEMA_VERSION, command: spec.merge(name: key) }
    end

    def all_data
      {
        schema_version: SCHEMA_VERSION,
        commands: COMMANDS.map do |name, spec|
          spec.slice(:category, :summary, :usage, :effect, :output, :help_topic).merge(name:)
        end
      }
    end
  end
end
