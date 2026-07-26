# frozen_string_literal: true

module Partitura
  module Production
    class Readout
      module CompositionGraphViews
        def composition_graph_view(json: false)
          graph = CompositionGraph.build(piece)
          return JSON.pretty_generate(graph.to_h) if json

          lines = ["# Composition Graph #{piece.title}", "digest: #{graph.graph_digest}", ""]
          graph.nodes.each do |node|
            indent = { piece: "", section: "  ", span: "    ", phrase: "      ", placement: "      ",
                       material: "  " }.fetch(node.type)
            scope = node.bars && " bars=#{node.bars.begin}-#{node.bars.end}"
            stability = node.stable ? nil : " [unstable legacy path]"
            lines << "#{indent}#{node.path}#{scope}#{stability}"
          end
          append_relation_lines(lines, graph)
          lines.join("\n")
        end

        def composition_plan_view(json: false)
          graph = CompositionGraph.build(piece)
          return JSON.pretty_generate(graph.to_h.fetch("requirements")) if json

          lines = ["# Composition Plan #{piece.title}"]
          materials = graph.nodes.select { |node| node.type == :material }
          unless materials.empty?
            lines << ""
            lines << "materials:"
            materials.each do |node|
              identity = node.attributes.fetch(:identity, {}).map { |key, value| "#{key}=#{value}" }.join("; ")
              lines << "- #{node.path}: #{identity}"
            end
          end
          lines << ""
          lines << "requirements:"
          if graph.requirements.empty?
            lines << "- (none)"
          else
            graph.requirements.each { |requirement| lines << requirement_line(requirement) }
          end
          lines.join("\n")
        end

        def composition_resolution_view(json: false)
          graph = CompositionGraph.build(piece)
          requirements = graph.requirements
          return JSON.pretty_generate(requirements.map(&:to_h)) if json

          counts = %i[open partial bound].to_h { |state| [state, requirements.count { |item| item.state == state }] }
          lines = [
            "# Composition Resolution #{piece.title}",
            "open=#{counts[:open]} partial=#{counts[:partial]} bound=#{counts[:bound]}"
          ]
          lines << ""
          if requirements.empty?
            lines << "(no declared requirements)"
          else
            requirements.each { |requirement| lines << requirement_line(requirement) }
          end
          lines.join("\n")
        end

        def composition_snapshot_view(json: false)
          snapshot = CompositionGraph::Snapshot.new(piece)
          return JSON.pretty_generate(snapshot.to_h) if json

          data = snapshot.to_h
          score = data.fetch("score")
          [
            "# Composition Snapshot #{piece.title}",
            "graph_digest: #{data.fetch('graph_digest')}",
            "snapshot_digest: #{data.fetch('snapshot_digest')}",
            "parts: #{score.fetch('parts').length}",
            "phrases: #{score.fetch('phrases').length}",
            "placements: #{score.fetch('placements').length}",
            "timed_events: #{score.fetch('timed_events').length}",
            "rerun with --json for the versioned interchange payload"
          ].join("\n")
        end

        private

        def append_relation_lines(lines, graph)
          lines << ""
          lines << "relations:"
          graph.relations.each do |relation|
            authored = relation.authored ? "authored" : "derived"
            lines << "- #{relation.kind}: #{relation.from} -> #{relation.to} (#{authored})"
          end
        end

        def requirement_line(requirement)
          selector = requirement.selector && ":#{requirement.selector}"
          relation = requirement.relation && " relation=#{requirement.relation}"
          coverage = requirement.coverage == :presence ? nil : " coverage=#{requirement.coverage}"
          bindings = requirement.bindings.empty? ? "(none)" : requirement.bindings.join(", ")
          "- [#{requirement.state}] #{requirement.owner} #{requirement.facet}#{selector}" \
            "#{relation}#{coverage} -> #{bindings}"
        end
      end
    end
  end
end
