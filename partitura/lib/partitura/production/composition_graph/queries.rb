# frozen_string_literal: true

module Partitura
  module Production
    module CompositionGraph
      class RequirementRecord
        def key
          [owner, facet, selector, relation, coverage].map(&:to_s).join("|")
        end
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

        private

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
