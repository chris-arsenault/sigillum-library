# frozen_string_literal: true

require_relative "models"

module Partitura
  module Production
    module Evaluation
      class ScoreMeasurement
        def self.from_source(source_path)
          new(source_path).measure
        end

        def initialize(source_path)
          @source_path = File.expand_path(source_path)
          unless File.file?(@source_path)
            raise Error.new("missing_source", "score source does not exist: #{@source_path}")
          end

          @source = File.binread(@source_path)
        end

        def measure
          piece = load_piece
          return piece if piece.is_a?(Hash)

          response = piece.compile_response
          return invalid_profile(:compile, response) unless response.fetch(:status) == "ok"

          valid_profile(piece)
        rescue Production::CompileError => e
          invalid_profile(:compile, e.response)
        rescue StandardError => e
          invalid_profile(:evaluation, code: e.class.name, message: stable_message(e.message))
        end

        private

        def load_piece
          Production.load_file(@source_path)
        rescue SyntaxError => e
          invalid_profile(
            :source_load, code: "ruby_syntax_error", message: stable_message(e.message)
          )
        rescue Production::CompileError => e
          invalid_profile(:source_load, e.response)
        rescue StandardError => e
          invalid_profile(:source_load, code: e.class.name, message: stable_message(e.message))
        end

        def valid_profile(piece)
          data = Production.export_data(piece)
          snapshot = CompositionGraph::Snapshot.new(piece)
          musicxml = Partitura.production_musicxml(piece)
          midi = Partitura.production_midi(piece)
          base_profile.merge(
            graph_digest: snapshot.graph_digest,
            snapshot_digest: snapshot.snapshot_digest,
            mechanical: mechanical_profile(valid: true),
            diagnostics: diagnostics(piece, data, snapshot.graph),
            fingerprints: fingerprints(data),
            artifact_digests: {
              musicxml: Validation.sha256(musicxml),
              midi: Validation.sha256(midi)
            }
          )
        end

        def invalid_profile(stage, detail)
          base_profile.merge(
            mechanical: mechanical_profile(valid: false, stage: stage),
            failure: canonical_failure(detail)
          )
        end

        def base_profile
          {
            schema_version: PROFILE_SCHEMA_VERSION,
            kind: "partitura_score_measurement",
            source_name: File.basename(@source_path),
            source_digest: Validation.sha256(@source)
          }
        end

        def mechanical_profile(valid:, stage: nil)
          stages = %i[source_load compile musicxml_export midi_export]
          failed_index = stage && stages.index(stage)
          values = stages.to_h do |item|
            passed = valid || (failed_index && stages.index(item) < failed_index)
            [item, passed == true]
          end
          values.merge(valid: valid)
        end

        def diagnostics(piece, data, graph)
          {
            requirements: requirement_diagnostics(graph),
            identity: identity_diagnostics(graph),
            seams: seam_diagnostics(piece, data),
            texture: texture_diagnostics(data),
            reserve: reserve_diagnostics(data)
          }
        end

        def requirement_diagnostics(graph)
          requirements = graph.requirements
          counts = %i[open partial bound].to_h do |state|
            [state, requirements.count { |item| item.state == state }]
          end
          counts.merge(
            declared: requirements.length,
            bound_ratio: ratio(counts.fetch(:bound), requirements.length)
          )
        end

        def identity_diagnostics(graph)
          phrases = graph.nodes.select { |node| node.type == :phrase }
          linked = phrases.count { |node| node.attributes.key?(:material) }
          relations = graph.relations.select(&:authored)
          {
            material_count: graph.nodes.count { |node| node.type == :material },
            phrase_count: phrases.length,
            material_linked_phrase_count: linked,
            material_linked_phrase_ratio: ratio(linked, phrases.length),
            derives_from_count: relations.count { |item| item.kind == :derives_from },
            returns_to_count: relations.count { |item| item.kind == :returns_to }
          }
        end

        def seam_diagnostics(piece, data)
          boundaries = piece.sections.flat_map(&:spans).map do |span|
            piece.offset_for(span.bars.begin, 1).to_f
          end.uniq.sort.reject(&:zero?)
          sounding = sounding_events(data)
          {
            boundary_count: boundaries.length,
            attack_boundary_count: boundaries.count { |point| attack_at?(sounding, point) },
            sustained_boundary_count: boundaries.count { |point| sustained_at?(sounding, point) },
            silent_boundary_count: boundaries.count { |point| silent_at?(sounding, point) }
          }
        end

        def texture_diagnostics(data)
          sounding = sounding_events(data)
          {
            part_count: Array(data.fetch(:parts)).length,
            sounding_event_count: sounding.length,
            role_count: sounding.map { |event| event.fetch(:role) }.uniq.length,
            pitch_vocabulary: sounding.flat_map do |event|
              [event[:pitch], *Array(event[:pitches])]
            end.compact.uniq.length,
            duration_vocabulary: sounding.map { |event| event.fetch(:duration_ql) }.uniq.length
          }
        end

        def reserve_diagnostics(data)
          duration = data.fetch(:total_duration_ql).to_f
          parts = Array(data.fetch(:parts)).map { |part| part.fetch(:id).to_s }
          occupied = parts.sum do |part|
            interval_union_duration(sounding_events(data).select { |event| event.fetch(:part) == part })
          end
          capacity = duration * parts.length
          {
            total_duration_ql: duration,
            sounding_occupancy_ratio: ratio(occupied, capacity),
            silence_ratio: capacity.zero? ? nil : (1.0 - occupied / capacity).round(6),
            attacks_per_quarter: ratio(sounding_events(data).length, duration)
          }
        end

        def fingerprints(data)
          events = sounding_events(data).group_by { |event| event.fetch(:part) }
          tokens = events.keys.sort.flat_map do |part|
            sequence = events.fetch(part).sort_by { |event| event.fetch(:offset_ql) }
                                   .map { |event| event_token(event) }
            ngrams(sequence)
          end
          {
            score: CompositionGraph::Canonical.digest(tokens),
            event_ngrams: tokens.map { |token| Validation.sha256(token) }.uniq.sort
          }
        end

        def event_token(event)
          [
            event.fetch(:part), event.fetch(:role), event.fetch(:offset_ql),
            event.fetch(:duration_ql), event[:pitch], event[:pitches], event.fetch(:event_type)
          ].join("|")
        end

        def ngrams(sequence)
          return sequence if sequence.length < 3

          sequence.each_cons(3).map { |items| items.join(">>") }
        end

        def sounding_events(data)
          Array(data.fetch(:timed_events)).reject { |event| event.fetch(:rest) }
        end

        def attack_at?(events, point)
          events.any? { |event| event.fetch(:offset_ql).to_f == point }
        end

        def sustained_at?(events, point)
          events.any? do |event|
            event.fetch(:offset_ql).to_f < point && event.fetch(:end_offset_ql).to_f > point
          end
        end

        def silent_at?(events, point)
          !events.any? do |event|
            event.fetch(:offset_ql).to_f <= point && event.fetch(:end_offset_ql).to_f > point
          end
        end

        def interval_union_duration(events)
          intervals = events.map do |event|
            [event.fetch(:offset_ql).to_f, event.fetch(:end_offset_ql).to_f]
          end.sort
          intervals.each_with_object([]) do |interval, merged|
            if merged.empty? || merged.last.last < interval.first
              merged << interval
            else
              merged.last[1] = [merged.last.last, interval.last].max
            end
          end.sum { |start, finish| finish - start }
        end

        def ratio(numerator, denominator)
          return if denominator.zero?

          (numerator.to_f / denominator).round(6)
        end

        def canonical_failure(detail)
          value = detail.respond_to?(:to_h) ? detail.to_h : detail
          CompositionGraph::Canonical.value(value)
        end

        def stable_message(message)
          message.to_s.gsub(@source_path, File.basename(@source_path))
        end
      end
    end
  end
end
