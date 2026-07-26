# frozen_string_literal: true

module Partitura
  module Production
    module CompositionGraph
      class Snapshot
        SCHEMA_VERSION = 1

        attr_reader :piece, :graph

        def initialize(piece, graph: CompositionGraph.build(piece))
          @piece = piece
          @graph = graph
        end

        def graph_digest
          graph.graph_digest
        end

        def snapshot_digest
          @snapshot_digest ||= Canonical.digest(digest_payload)
        end

        def to_h
          Canonical.value(
            schema_version: SCHEMA_VERSION,
            graph_digest: graph_digest,
            snapshot_digest: snapshot_digest,
            graph: graph.to_h,
            score: score
          )
        end

        private

        def digest_payload
          {
            schema_version: SCHEMA_VERSION,
            graph: graph.to_h.reject { |key, _| key == "graph_digest" },
            score: score
          }
        end

        def score
          @score ||= normalize_score(Production.export_data(piece))
        end

        def normalize_score(data)
          normalize(
            title: data.fetch(:title),
            piece_path: graph.piece_path.to_s,
            parts: data.fetch(:parts),
            meter_events: data.fetch(:meter_events),
            key_events: opening_key_event(data) + data.fetch(:key_changes),
            tempo_events: data.fetch(:tempo_events),
            controls: data.fetch(:controls),
            phrases: data.fetch(:phrases),
            placements: data.fetch(:placements),
            timed_events: data.fetch(:timed_events)
          )
        end

        def opening_key_event(data)
          [{ key: data.fetch(:key), at: "bar 1 beat 1", offset_ql: 0 }]
        end

        def normalize(value, key = nil)
          case value
          when Hash
            value.each_with_object({}) do |(child_key, child_value), out|
              out[child_key.to_s] = normalize(child_value, child_key.to_s)
            end.sort.to_h
          when Array
            value.map { |item| normalize(item) }
          when Symbol
            value.to_s
          when Numeric
            rational_key?(key) ? rationalized(value) : value
          else
            value
          end
        end

        def rational_key?(key)
          key == "beat" || key.to_s.end_with?("_ql")
        end

        def rationalized(value)
          rational = Rational(value.to_s).rationalize(Rational(1, 1_000_000))
          Canonical.rational(rational)
        end
      end

      module_function

      def snapshot(piece)
        Snapshot.new(piece).to_h
      end
    end
  end
end
