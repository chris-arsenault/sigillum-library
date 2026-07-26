# frozen_string_literal: true

module Partitura
  module Production
    module CompositionGraph
      NODE_TYPES = %i[piece section span material phrase placement].freeze
      REQUIREMENT_FACETS = %i[harmony material role part texture control checkpoint].freeze
      COVERAGE_MODES = %i[presence all_bars].freeze
      ALL_BARS_FACETS = %i[harmony role part].freeze
      MATERIAL_RELATIONS = %i[statement return variation fragment].freeze
      RELATION_KINDS = %i[contains realizes derives_from returns_to depends_on].freeze
      AUTHORED_RELATION_KINDS = %i[derives_from returns_to depends_on].freeze
      MATERIAL_IDENTITY_FACETS = %i[pitch rhythm harmony register texture orchestration].freeze

      class Path
        attr_reader :type, :id

        def initialize(type, id)
          @type = type.to_sym
          @id = id.to_s.freeze
          freeze
        end

        def to_s
          "#{type}:#{id}"
        end

        def ==(other)
          other.is_a?(Path) && other.type == type && other.id == id
        end
        alias eql? ==

        def hash
          [type, id].hash
        end

        def self.parse(value)
          type, id = value.to_s.split(":", 2)
          return unless type && id && !id.empty?

          new(type, id)
        end
      end

      class Reference
        attr_reader :type, :id

        def initialize(type, id)
          @type = type.to_sym
          @id = id.to_sym
          freeze
        end

        def path
          Path.new(type, id)
        end
      end

      class Material
        attr_reader :id, :identity

        def initialize(id)
          @id = id.to_sym
          @identity = {}
        end

        def set_identity(facets)
          facets.each { |facet, value| @identity[facet.to_sym] = value.to_s }
        end
      end

      class Requirement
        attr_reader :facet, :selector, :coverage, :relation

        def initialize(facet, selector = nil, coverage: :presence, relation: nil)
          @facet = facet.to_sym
          @selector = selector&.to_sym
          @coverage = coverage.to_sym
          @relation = relation&.to_sym
        end

        def key
          [facet, selector, relation]
        end
      end

      class Relation
        attr_reader :kind, :from, :to, :metadata

        def initialize(kind, from:, to:, **metadata)
          @kind = kind.to_sym
          @from = from
          @to = to
          @metadata = metadata.transform_keys(&:to_sym)
        end
      end
    end
  end
end
