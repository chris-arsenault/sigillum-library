# frozen_string_literal: true

module Partitura
  module Production
    module CompositionGraph
      class RequirementRecord
        def key
          [owner, facet, selector, relation, coverage].map(&:to_s).join("|")
        end
      end

      class ConnectionRecord
        attr_reader :kind, :from, :to, :metadata, :authored, :direction, :origin, :neighbor

        def initialize(relation, origin:)
          @kind = relation.kind
          @from = relation.from
          @to = relation.to
          @metadata = relation.metadata
          @authored = relation.authored
          @origin = origin
          @direction = relation.from == origin ? :outgoing : :incoming
          @neighbor = direction == :outgoing ? relation.to : relation.from
          freeze
        end

        def to_h
          {
            kind: kind, from: from.to_s, to: to.to_s, metadata: metadata,
            authored: authored, direction: direction, origin: origin.to_s,
            neighbor: neighbor.to_s
          }
        end
      end

      class NodeInspection
        attr_reader :object, :requirements, :connections

        def initialize(object:, requirements:, connections:)
          @object = object
          @requirements = requirements.freeze
          @connections = connections.freeze
          freeze
        end

        def to_h
          {
            object: object.to_h,
            requirements: requirements.map(&:to_h),
            connections: connections.map(&:to_h)
          }
        end
      end

      class PathResult
        attr_reader :from, :to, :max_hops, :found, :steps

        def initialize(from:, to:, max_hops:, found:, steps:)
          @from = from
          @to = to
          @max_hops = max_hops
          @found = found
          @steps = steps&.freeze
          freeze
        end

        def to_h
          {
            from: from.to_s, to: to.to_s, max_hops: max_hops,
            found: found, steps: steps&.map(&:to_h)
          }
        end
      end

      def self.vocabulary
        {
          node_types: NODE_TYPES,
          requirement_facets: REQUIREMENT_FACETS,
          coverage_modes: COVERAGE_MODES,
          material_relations: MATERIAL_RELATIONS,
          relation_kinds: RELATION_KINDS,
          authored_relation_kinds: AUTHORED_RELATION_KINDS,
          material_identity_facets: MATERIAL_IDENTITY_FACETS
        }.freeze
      end

      class Graph
        def require_stable(path)
          target = node(path)
          raise ArgumentError, "unknown graph path #{path}" unless target
          unless target.stable
            raise ArgumentError, "workflow records may not target unstable graph path #{path}"
          end

          target
        end

        def descendants(path, include_self: false)
          target = require_path(path)
          selected = include_self ? [target] : []
          frontier = [target]
          until frontier.empty?
            children = children_of(frontier.shift)
            selected.concat(children)
            frontier.concat(children)
          end
          selected.freeze
        end

        def lineage(path)
          current = require_path(path)
          selected = [current]
          while (parent = node(current).parent_path)
            selected << parent
            current = parent
          end
          selected.freeze
        end

        def requirements_at(path, states: nil, include_descendants: false)
          target = require_path(path)
          owners = [target]
          owners.concat(descendants(target)) if include_descendants
          allowed = states&.map(&:to_sym)
          @requirements.select do |requirement|
            owners.include?(requirement.owner) &&
              (!allowed || allowed.include?(requirement.state))
          end.freeze
        end

        def dependencies_for(path)
          targets = lineage(path)
          @relations.select do |relation|
            relation.kind == :depends_on && targets.include?(relation.from)
          end.map(&:to).uniq.sort_by(&:to_s).freeze
        end

        def show(path)
          target = require_path(path)
          NodeInspection.new(
            object: node(target), requirements: requirements_at(target),
            connections: connections(target)
          )
        end

        def connections(path)
          target = require_path(path)
          @relations.filter_map do |relation|
            ConnectionRecord.new(relation, origin: target) if relation.from == target || relation.to == target
          end.sort_by do |connection|
            [connection.neighbor.to_s, connection.kind.to_s, connection.from.to_s,
             connection.to.to_s, Canonical.json(connection.metadata)]
          end.freeze
        end

        def shortest_path(from, to, max_hops: 6)
          limit = Integer(max_hops)
          raise ArgumentError, "max_hops must be between 1 and 20" unless (1..20).cover?(limit)

          start = require_path(from)
          finish = require_path(to)
          return PathResult.new(from: start, to: finish, max_hops: limit, found: true, steps: []) if start == finish

          route = find_route(start, finish, limit)
          PathResult.new(from: start, to: finish, max_hops: limit, found: !route.nil?, steps: route)
        end

        private

        def find_route(start, finish, limit)
          queue = [[start, []]]
          visited = { start => true }
          until queue.empty?
            current, steps = queue.shift
            next if steps.length >= limit

            connections(current).each do |connection|
              next if visited[connection.neighbor]

              route = steps + [connection]
              return route if connection.neighbor == finish

              visited[connection.neighbor] = true
              queue << [connection.neighbor, route]
            end
          end
          nil
        end

        def require_path(value)
          path = value.is_a?(Path) ? value : Path.parse(value)
          raise ArgumentError, "unknown graph path #{value}" unless path && node(path)

          path
        end

        def children_of(parent)
          nodes.select { |item| item.parent_path == parent }
               .map(&:path)
               .sort_by(&:to_s)
        end
      end
    end
  end
end
