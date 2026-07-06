# frozen_string_literal: true

require_relative "orchestral_dsl/model"
require_relative "orchestral_dsl/parser"
require_relative "orchestral_dsl/builders"
require_relative "orchestral_dsl/projections"
require_relative "orchestral_dsl/surface_lab"
require_relative "orchestral_dsl/jit_docs"
require_relative "orchestral_dsl/production"

module Sigillum
  module OrchestralDSL
    module_function

    def piece(title, &block)
      PieceBuilder.new(title).build(&block)
    end

    def load_file(path)
      context = Object.new
      context.define_singleton_method(:piece) do |title, &block|
        Sigillum::OrchestralDSL.piece(title, &block)
      end
      context.instance_eval(File.read(path), path.to_s)
    end

    def projection(piece, name, **options)
      Projections.new(piece).render(name, **options)
    end

    def help(topic = :index)
      JITDocs.render(topic)
    end

    def help_data(topic = :index)
      JITDocs.data(topic)
    end

    def hybrid_piece(title, &block)
      Production.piece(title, &block)
    end

    def production_piece(title, &block)
      Production.piece(title, &block)
    end

    def load_hybrid_file(path)
      Production.load_file(path)
    end

    def load_production_file(path)
      Production.load_file(path)
    end

    def production_readout(piece, view = :structure, **options)
      Production.readout(piece, view, **options)
    end

    def production_transport_hash(piece)
      Production.transport_hash(piece)
    end

    def production_transport_json(piece)
      Production.transport_json(piece)
    end
  end
end
