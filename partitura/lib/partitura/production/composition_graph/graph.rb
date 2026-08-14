# frozen_string_literal: true

require_relative "canonical"

module Partitura
  module Production
    module CompositionGraph
      class Node
        attr_reader :type, :path, :parent_path, :stable, :bars, :attributes

        def initialize(type:, path:, parent_path: nil, stable:, bars: nil, attributes: {})
          @type = type.to_sym
          @path = path
          @parent_path = parent_path
          @stable = stable
          @bars = bars
          @attributes = Canonical.immutable(attributes)
          freeze
        end

        def to_h
          {
            type: type,
            path: path.to_s,
            parent: parent_path&.to_s,
            stable: stable,
            bars: bars,
            attributes: attributes
          }.compact
        end
      end

      class RequirementRecord
        attr_reader :owner, :facet, :selector, :coverage, :relation, :state, :bindings, :covered_bars

        def initialize(owner:, facet:, selector:, coverage:, relation:, state:, bindings:, covered_bars:)
          @owner = owner
          @facet = facet.to_sym
          @selector = selector&.to_sym
          @coverage = coverage.to_sym
          @relation = relation&.to_sym
          @state = state.to_sym
          @bindings = bindings.sort.freeze
          @covered_bars = covered_bars.sort.freeze
          freeze
        end

        def to_h
          {
            owner: owner.to_s,
            facet: facet,
            selector: selector,
            coverage: coverage,
            relation: relation,
            state: state,
            bindings: bindings,
            covered_bars: covered_bars
          }.compact
        end
      end

      class RelationRecord
        attr_reader :kind, :from, :to, :metadata, :authored

        def initialize(kind:, from:, to:, metadata: {}, authored:)
          @kind = kind.to_sym
          @from = from
          @to = to
          @metadata = Canonical.immutable(metadata)
          @authored = authored
          freeze
        end

        def to_h
          {
            kind: kind,
            from: from.to_s,
            to: to.to_s,
            metadata: metadata,
            authored: authored
          }
        end
      end

      class Graph
        SCHEMA_VERSION = 1

        attr_reader :piece_path, :nodes

        def initialize(piece_path:, nodes:, requirements:, relations:, object_paths:)
          @piece_path = piece_path
          @nodes = nodes.sort_by { |node| node.path.to_s }.freeze
          @requirements = requirements.sort_by do |requirement|
            [requirement.owner.to_s, requirement.facet.to_s, requirement.selector.to_s,
             requirement.relation.to_s, requirement.coverage.to_s]
          end.freeze
          @relations = relations.sort_by do |relation|
            [relation.kind.to_s, relation.from.to_s, relation.to.to_s, Canonical.json(relation.metadata)]
          end.freeze
          @object_paths = object_paths.freeze
          @nodes_by_path = @nodes.to_h { |node| [node.path.to_s, node] }.freeze
        end

        def node(path)
          @nodes_by_path[path.to_s]
        end

        def path_for(object)
          @object_paths[object.object_id]
        end

        def requirements(state: nil)
          return @requirements unless state

          @requirements.select { |requirement| requirement.state == state.to_sym }
        end

        def relations(kind: nil)
          return @relations unless kind

          @relations.select { |relation| relation.kind == kind.to_sym }
        end

        def all_bound?
          @requirements.all? { |requirement| requirement.state == :bound }
        end

        def graph_digest
          @graph_digest ||= Canonical.digest(payload)
        end

        def to_h
          Canonical.value(payload.merge(graph_digest: graph_digest))
        end

        private

        def payload
          {
            schema_version: SCHEMA_VERSION,
            piece: piece_path.to_s,
            nodes: nodes.map(&:to_h),
            requirements: @requirements.map(&:to_h),
            relations: @relations.map(&:to_h)
          }
        end
      end

      class Builder
        SELECTOR_REQUIRED = %i[material role part texture control].freeze
        SELECTOR_FORBIDDEN = %i[harmony checkpoint].freeze
        ENDPOINT_TYPES = {
          derives_from: %i[material phrase],
          returns_to: %i[span material phrase],
          depends_on: %i[piece section span material]
        }.freeze

        def initialize(piece)
          @piece = piece
          @nodes = []
          @nodes_by_path = {}
          @object_paths = {}
          @relations = []
          @owner_entries = []
          @span_entries = []
          @phrase_entries = []
          @placement_entries = []
          @phrase_by_id = {}
          @issues = []
          @legacy_span = 0
          @legacy_placement = 0
        end

        def build
          collect_nodes
          validate_graph_mode
          validate_materials_and_phrases
          validate_requirements
          collect_authored_relations
          validate_relation_cycles
          raise_invalid! unless @issues.empty?

          requirements = @owner_entries.flat_map { |entry| resolve_requirements(entry) }
          Graph.new(
            piece_path: @object_paths.fetch(@piece.object_id),
            nodes: @nodes,
            requirements: requirements,
            relations: @relations,
            object_paths: @object_paths
          )
        end

        private

        def collect_nodes
          piece_path = path(:piece, @piece.id || :legacy_piece)
          add_node(@piece, :piece, piece_path, stable: !@piece.id.nil?, attributes: { title: @piece.title })
          add_owner(@piece, piece_path, :piece)
          collect_materials
          @piece.sections.each do |section|
            section_path = path(:section, section.id)
            add_node(section, :section, section_path, parent: piece_path, stable: true, bars: section.bars,
                     attributes: { name: section.name, type: section.type })
            add_relation(:contains, piece_path, section_path, authored: false)
            add_owner(section, section_path, :section, section: section)
            section.spans.each { |span| collect_span(section, span, section_path) }
          end
        end

        def collect_materials
          @piece.materials.each_value do |material|
            material_path = path(:material, material.id)
            add_node(material, :material, material_path, stable: true, attributes: { identity: material.identity })
          end
        end

        def collect_span(section, span, section_path)
          @legacy_span += 1
          span_path = path(:span, span.id || format("legacy_span_%03d", @legacy_span))
          add_node(span, :span, span_path, parent: section_path, stable: !span.id.nil?, bars: span.bars,
                   attributes: { texture: span.texture })
          add_relation(:contains, section_path, span_path, authored: false)
          add_owner(span, span_path, :span, section: section, span: span)
          @span_entries << { section: section, span: span, path: span_path }
          validate_temporal_containment(section, span, span_path)
          span.phrase_definitions.each { |phrase| collect_phrase(phrase, span, span_path) }
          span.placements.each { |placement| collect_placement(placement, section, span, span_path) }
        end

        def collect_phrase(phrase, span, span_path)
          phrase_path = path(:phrase, phrase.id)
          add_node(phrase, :phrase, phrase_path, parent: span_path, stable: true,
                   attributes: {
                     surface: phrase.surface,
                     material: phrase.material_id,
                     relation: phrase.material_relation
                   }.compact)
          add_relation(:contains, span_path, phrase_path, authored: false)
          @phrase_entries << { phrase: phrase, span: span, path: phrase_path }
          @phrase_by_id[phrase.id] ||= { phrase: phrase, path: phrase_path }
          return unless phrase.material_id

          material_path = path(:material, phrase.material_id)
          add_relation(:realizes, phrase_path, material_path,
                       metadata: { relation: phrase.material_relation }.compact, authored: false)
        end

        def collect_placement(placement, section, span, span_path)
          @legacy_placement += 1
          placement_path = path(
            :placement,
            placement.id || format("legacy_placement_%03d", @legacy_placement)
          )
          add_node(placement, :placement, placement_path, parent: span_path, stable: !placement.id.nil?,
                   bars: placement.bar..placement.bar,
                   attributes: {
                     phrase: path(:phrase, placement.phrase_id).to_s,
                     part: placement.part,
                     role: placement.role,
                     bar: placement.bar,
                     beat: placement.beat
                   })
          add_relation(:contains, span_path, placement_path, authored: false)
          add_relation(:realizes, placement_path, path(:phrase, placement.phrase_id), authored: false)
          @placement_entries << {
            placement: placement, section: section, span: span, path: placement_path
          }
          return if span.bars.cover?(placement.bar)

          issue(
            "placement_outside_span",
            "#{placement_path} at bar #{placement.bar} is outside #{span_path} bars " \
            "#{span.bars.begin}-#{span.bars.end}.",
            [placement_path, span_path]
          )
        end

        def validate_temporal_containment(section, span, span_path)
          return if section.bars.cover?(span.bars.begin) && section.bars.cover?(span.bars.end)

          issue(
            "span_outside_section",
            "#{span_path} bars #{span.bars.begin}-#{span.bars.end} are outside section:#{section.id} bars " \
            "#{section.bars.begin}-#{section.bars.end}.",
            [span_path, path(:section, section.id)]
          )
        end

        def add_owner(object, object_path, type, section: nil, span: nil)
          @owner_entries << {
            object: object, path: object_path, type: type, section: section, span: span
          }
        end

        def add_node(object, type, object_path, parent: nil, stable:, bars: nil, attributes: {})
          if @nodes_by_path.key?(object_path.to_s)
            issue("duplicate_#{type}_id", "#{object_path} is defined more than once.", [object_path])
            return
          end

          node = Node.new(
            type: type, path: object_path, parent_path: parent, stable: stable, bars: bars,
            attributes: attributes
          )
          @nodes << node
          @nodes_by_path[object_path.to_s] = node
          @object_paths[object.object_id] = object_path
        end

        def add_relation(kind, from, to, metadata: {}, authored:)
          @relations << RelationRecord.new(
            kind: kind, from: from, to: to, metadata: metadata, authored: authored
          )
        end

        def validate_graph_mode
          return unless @piece.graph_enabled?

          issue("missing_piece_id", "Graph-enabled source must declare `production_piece ..., id:`.") unless @piece.id
          @span_entries.each do |entry|
            next if entry.fetch(:span).id

            issue("missing_span_id", "#{entry.fetch(:path)} needs an explicit span id.", [entry.fetch(:path)])
          end
          @placement_entries.each do |entry|
            next if entry.fetch(:placement).id

            issue(
              "missing_placement_id",
              "#{entry.fetch(:path)} needs an explicit placement `id:`.",
              [entry.fetch(:path)]
            )
          end
        end

        def validate_materials_and_phrases
          @piece.materials.each_value do |material|
            if material.identity.empty?
              issue(
                "material_identity_empty",
                "material:#{material.id} needs at least one audible identity facet.",
                [path(:material, material.id)]
              )
            end
            unknown = material.identity.keys - MATERIAL_IDENTITY_FACETS
            next if unknown.empty?

            issue(
              "unknown_material_identity_facet",
              "material:#{material.id} uses unknown identity facets: #{unknown.join(', ')}.",
              [path(:material, material.id)]
            )
          end

          @phrase_entries.each do |entry|
            phrase = entry.fetch(:phrase)
            if phrase.material_id && !@piece.materials.key?(phrase.material_id)
              issue(
                "unknown_material",
                "phrase:#{phrase.id} references unknown material:#{phrase.material_id}.",
                [entry.fetch(:path), path(:material, phrase.material_id)]
              )
            end
            if phrase.material_id && phrase.material_relation.nil?
              issue(
                "missing_material_relation",
                "phrase:#{phrase.id} links material:#{phrase.material_id} without a relation.",
                [entry.fetch(:path)]
              )
            end
            if phrase.material_relation && !MATERIAL_RELATIONS.include?(phrase.material_relation)
              issue(
                "unknown_material_relation",
                "phrase:#{phrase.id} uses unknown material relation #{phrase.material_relation.inspect}.",
                [entry.fetch(:path)]
              )
            end
            next unless phrase.material_relation && phrase.material_id.nil?

            issue(
              "material_relation_without_material",
              "phrase:#{phrase.id} declares a material relation without `material:`.",
              [entry.fetch(:path)]
            )
          end

          @placement_entries.each do |entry|
            placement = entry.fetch(:placement)
            next if @phrase_by_id.key?(placement.phrase_id)

            issue(
              "unknown_phrase",
              "#{entry.fetch(:path)} references unknown phrase:#{placement.phrase_id}.",
              [entry.fetch(:path), path(:phrase, placement.phrase_id)]
            )
          end
        end

        def validate_requirements
          @owner_entries.each do |entry|
            seen = {}
            entry.fetch(:object).plan_requirements.each do |requirement|
              validate_requirement(entry, requirement)
              if seen.key?(requirement.key)
                issue(
                  "duplicate_requirement",
                  "#{entry.fetch(:path)} repeats requirement #{requirement.key.inspect}.",
                  [entry.fetch(:path)]
                )
              end
              seen[requirement.key] = true
            end
          end
        end

        def validate_requirement(entry, requirement)
          owner_path = entry.fetch(:path)
          unless REQUIREMENT_FACETS.include?(requirement.facet)
            issue(
              "unknown_requirement_facet",
              "#{owner_path} uses unknown requirement facet #{requirement.facet.inspect}.",
              [owner_path]
            )
          end
          unless COVERAGE_MODES.include?(requirement.coverage)
            issue(
              "unknown_coverage",
              "#{owner_path} uses unknown coverage #{requirement.coverage.inspect}.",
              [owner_path]
            )
          end
          if requirement.coverage == :all_bars && !ALL_BARS_FACETS.include?(requirement.facet)
            issue(
              "unsupported_coverage",
              "#{owner_path} cannot use all_bars coverage for #{requirement.facet}.",
              [owner_path]
            )
          end
          if SELECTOR_REQUIRED.include?(requirement.facet) && requirement.selector.nil?
            issue(
              "missing_requirement_selector",
              "#{owner_path} requirement #{requirement.facet} needs a selector.",
              [owner_path]
            )
          end
          if SELECTOR_FORBIDDEN.include?(requirement.facet) && requirement.selector
            issue(
              "unexpected_requirement_selector",
              "#{owner_path} requirement #{requirement.facet} does not accept a selector.",
              [owner_path]
            )
          end
          validate_requirement_reference(owner_path, requirement)
        end

        def validate_requirement_reference(owner_path, requirement)
          if requirement.relation && requirement.facet != :material
            issue(
              "unexpected_requirement_relation",
              "#{owner_path} relation is supported only for material requirements.",
              [owner_path]
            )
          end
          if requirement.relation && !MATERIAL_RELATIONS.include?(requirement.relation)
            issue(
              "unknown_material_relation",
              "#{owner_path} uses unknown material relation #{requirement.relation.inspect}.",
              [owner_path]
            )
          end
          if requirement.facet == :material && requirement.selector &&
             !@piece.materials.key?(requirement.selector)
            issue(
              "unknown_material",
              "#{owner_path} requires unknown material:#{requirement.selector}.",
              [owner_path, path(:material, requirement.selector)]
            )
          end
          return unless requirement.facet == :part && requirement.selector &&
                        !@piece.parts.key?(requirement.selector)

          issue(
            "unknown_part",
            "#{owner_path} requires unknown part #{requirement.selector}.",
            [owner_path]
          )
        end

        def collect_authored_relations
          @piece.graph_relations.each do |relation|
            unless AUTHORED_RELATION_KINDS.include?(relation.kind)
              issue(
                "unauthorable_relation",
                "Relation #{relation.kind.inspect} is derived or unknown; authored relations are " \
                "#{AUTHORED_RELATION_KINDS.join(', ')}."
              )
              next
            end
            from = reference_path(relation.from, relation.kind, :from)
            to = reference_path(relation.to, relation.kind, :to)
            next unless from && to

            allowed = ENDPOINT_TYPES.fetch(relation.kind)
            unless allowed.include?(from.type) && allowed.include?(to.type)
              issue(
                "invalid_relation_endpoint",
                "#{relation.kind} endpoints must both be one of #{allowed.join(', ')}; got #{from} -> #{to}.",
                [from, to]
              )
              next
            end
            add_relation(relation.kind, from, to, metadata: relation.metadata, authored: true)
          end
        end

        def reference_path(reference, kind, side)
          unless reference.is_a?(Reference)
            issue(
              "invalid_relation_reference",
              "#{kind} #{side} must use `ref(:type, :id)`."
            )
            return
          end

          target = reference.path
          return target if @nodes_by_path.key?(target.to_s)

          issue("unknown_relation_target", "#{kind} #{side} references unknown #{target}.", [target])
          nil
        end

        def validate_relation_cycles
          %i[derives_from depends_on].each do |kind|
            edges = @relations.select { |relation| relation.kind == kind && relation.authored }
            cycle = find_cycle(edges)
            next unless cycle

            issue(
              "#{kind}_cycle",
              "#{kind} relation contains a cycle: #{cycle.join(' -> ')}.",
              cycle.map { |item| Path.parse(item) }.compact
            )
          end
        end

        def find_cycle(relations)
          graph = relations.group_by { |relation| relation.from.to_s }
                           .transform_values { |items| items.map { |item| item.to.to_s } }
          visiting = {}
          visited = {}
          stack = []
          found = nil
          visit = lambda do |node|
            return if visited[node] || found
            if visiting[node]
              index = stack.index(node) || 0
              found = stack[index..] + [node]
              return
            end

            visiting[node] = true
            stack << node
            graph.fetch(node, []).each { |target| visit.call(target) }
            stack.pop
            visiting.delete(node)
            visited[node] = true
          end
          graph.keys.each { |node| visit.call(node) }
          found
        end

        def resolve_requirements(entry)
          entry.fetch(:object).plan_requirements.map do |requirement|
            bindings, covered_bars = binding_evidence(entry, requirement)
            needed = owner_bars(entry)
            state = if bindings.empty?
                      :open
                    elsif requirement.coverage == :all_bars && !(needed - covered_bars).empty?
                      :partial
                    else
                      :bound
                    end
            RequirementRecord.new(
              owner: entry.fetch(:path),
              facet: requirement.facet,
              selector: requirement.selector,
              coverage: requirement.coverage,
              relation: requirement.relation,
              state: state,
              bindings: bindings,
              covered_bars: covered_bars
            )
          end
        end

        def binding_evidence(entry, requirement)
          spans = spans_for(entry)
          case requirement.facet
          when :harmony then harmony_evidence(spans)
          when :material then material_evidence(spans, requirement)
          when :role then placement_evidence(spans) { |placement| placement.role == requirement.selector }
          when :part then placement_evidence(spans) { |placement| placement.part == requirement.selector }
          when :texture then texture_evidence(spans, requirement.selector)
          when :control then control_evidence(entry, requirement.selector)
          when :checkpoint then checkpoint_evidence(spans)
          else [[], []]
          end
        end

        def harmony_evidence(spans)
          bindings = []
          covered = []
          spans.each do |entry|
            next if entry.fetch(:span).chord_track.empty?

            bindings << entry.fetch(:path).to_s
            covered.concat(entry.fetch(:span).chord_track.keys)
          end
          [bindings.uniq, covered.uniq]
        end

        def material_evidence(spans, requirement)
          bindings = []
          covered = []
          placements_for(spans).each do |entry|
            phrase_entry = @phrase_by_id[entry.fetch(:placement).phrase_id]
            next unless phrase_entry

            phrase = phrase_entry.fetch(:phrase)
            next unless phrase.material_id == requirement.selector
            next if requirement.relation && phrase.material_relation != requirement.relation

            bars = sounding_bars(entry.fetch(:placement), phrase)
            next if bars.empty?

            bindings << phrase_entry.fetch(:path).to_s
            bindings << entry.fetch(:path).to_s
            covered.concat(bars)
          end
          [bindings.uniq, covered.uniq]
        end

        def placement_evidence(spans)
          bindings = []
          covered = []
          placements_for(spans).each do |entry|
            placement = entry.fetch(:placement)
            next unless yield placement

            phrase_entry = @phrase_by_id[placement.phrase_id]
            next unless phrase_entry

            bars = sounding_bars(placement, phrase_entry.fetch(:phrase))
            next if bars.empty?

            bindings << entry.fetch(:path).to_s
            covered.concat(bars)
          end
          [bindings.uniq, covered.uniq]
        end

        def texture_evidence(spans, selector)
          matching = spans.select { |entry| entry.fetch(:span).texture == selector }
          [matching.map { |entry| entry.fetch(:path).to_s }, matching.flat_map { |entry|
            entry.fetch(:span).bars.to_a
          }.uniq]
        end

        def control_evidence(entry, selector)
          bars = owner_bars(entry)
          matching = @piece.controls.select { |control| control.kind.to_sym == selector }
          covered = matching.flat_map { |control| control_bars(control) & bars }.uniq
          [covered.empty? ? [] : [entry.fetch(:path).to_s], covered]
        end

        def checkpoint_evidence(spans)
          matching = spans.select { |entry| entry.fetch(:span).staff_bars.any? }
          [
            matching.map { |entry| entry.fetch(:path).to_s },
            matching.flat_map { |entry| entry.fetch(:span).staff_bars.map(&:number) }.uniq
          ]
        end

        def spans_for(entry)
          case entry.fetch(:type)
          when :piece then @span_entries
          when :section then @span_entries.select { |candidate| candidate.fetch(:section).equal?(entry[:section]) }
          when :span then @span_entries.select { |candidate| candidate.fetch(:span).equal?(entry[:span]) }
          else []
          end
        end

        def placements_for(spans)
          span_ids = spans.map { |entry| entry.fetch(:span).object_id }
          @placement_entries.select { |entry| span_ids.include?(entry.fetch(:span).object_id) }
        end

        def owner_bars(entry)
          case entry.fetch(:type)
          when :piece then @piece.sections.flat_map { |section| section.bars.to_a }.uniq.sort
          when :section then entry.fetch(:section).bars.to_a
          when :span then entry.fetch(:span).bars.to_a
          else []
          end
        end

        def sounding_bars(placement, phrase)
          offset = @piece.placement_start_offset(placement)
          bars = []
          phrase.events.each do |event|
            event_start = offset
            event_end = offset + event.duration
            unless event.rest?
              @piece.sections.each do |section|
                section.bars.each do |bar|
                  bar_start = @piece.offset_for(bar, 1)
                  bar_end = @piece.offset_for(bar + 1, 1)
                  bars << bar if event_start < bar_end && event_end > bar_start
                end
              end
            end
            offset = event_end
          end
          bars.uniq.sort
        end

        def control_bars(control)
          if control.at
            point = @piece.offset_for_reference(control.at)
            bar = bar_at(point)
            bar ? [bar] : []
          else
            from = @piece.offset_for_reference(control.from)
            to = @piece.offset_for_reference(control.to)
            all_piece_bars.select do |bar|
              bar_start = @piece.offset_for(bar, 1)
              bar_end = @piece.offset_for(bar + 1, 1)
              from < bar_end && to > bar_start
            end
          end
        end

        def bar_at(offset)
          all_piece_bars.find do |bar|
            offset >= @piece.offset_for(bar, 1) && offset < @piece.offset_for(bar + 1, 1)
          end
        end

        def all_piece_bars
          @all_piece_bars ||= @piece.sections.flat_map { |section| section.bars.to_a }.uniq.sort
        end

        def path(type, id)
          Path.new(type, id)
        end

        def issue(code, message, paths = [])
          @issues << {
            code: code,
            message: message,
            paths: Array(paths).map(&:to_s)
          }
        end

        def raise_invalid!
          first = @issues.first
          raise CompileError.new(
            code: "composition_graph_invalid",
            message: "#{@issues.length} composition graph error(s); first: #{first.fetch(:message)}",
            repair_instruction: "Fix the graph declarations listed in `errors`, then rebuild the composition graph.",
            help_topic: "composition_graph",
            docs: ["docs/architecture/partitura/09_composition_graph.md"],
            extra: {
              errors: @issues,
              diagnostics: @issues.map { |issue| Diagnostics.for_issue(issue) }
            }
          )
        end
      end

      module_function

      def build(piece)
        Builder.new(piece).build
      end
    end
  end
end
