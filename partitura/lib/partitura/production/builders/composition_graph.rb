# frozen_string_literal: true

module Partitura
  module Production
    class PlanBuilder
      def initialize(owner)
        @owner = owner
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def requires(facet, selector = nil, coverage: :presence, relation: nil)
        @owner.add_plan_requirement(
          CompositionGraph::Requirement.new(facet, selector, coverage: coverage, relation: relation)
        )
      end
    end

    class MaterialBuilder
      def initialize(material)
        @material = material
      end

      def build(&block)
        instance_eval(&block) if block
        @material
      end

      def identity(**facets)
        @material.set_identity(facets)
      end
    end
  end
end
