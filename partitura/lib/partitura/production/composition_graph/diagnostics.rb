# frozen_string_literal: true

module Partitura
  module Production
    module CompositionGraph
      # Converts graph-construction issues into the shared diagnostic shape.
      module Diagnostics
        module_function

        def for_issue(issue)
          paths = issue.fetch(:paths)
          Diagnostic.new(
            severity: :error,
            code: issue.fetch(:code),
            message: issue.fetch(:message),
            object_path: paths.first,
            repair_instruction: "Correct the named composition graph declaration, then rebuild the graph.",
            help_topic: "composition_graph",
            details: { paths: paths, aggregate_code: "composition_graph_invalid" }
          ).to_h
        end
      end
    end
  end
end
