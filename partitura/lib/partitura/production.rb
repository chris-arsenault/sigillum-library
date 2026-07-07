# frozen_string_literal: true

require "json"
require_relative "production/formatting"
require_relative "production/chords"
require_relative "production/models"
require_relative "production/parser"
require_relative "production/lint"
require_relative "production/builders"
require_relative "production/sounding"
require_relative "production/transport"
require_relative "production/transport_metrics"
require_relative "production/melody_analysis"
require_relative "production/musicxml_import"
require_relative "production/readout"

module Partitura
  module Production
    module_function

    def piece(title, &block)
      PieceBuilder.new(title).build(&block)
    end

    def load_file(path)
      context = Object.new
      context.define_singleton_method(:hybrid_piece) do |title, &block|
        Production.piece(title, &block)
      end
      context.define_singleton_method(:production_piece) do |title, &block|
        Production.piece(title, &block)
      end
      context.define_singleton_method(:piece) do |title, &block|
        Production.piece(title, &block)
      end
      context.instance_eval(File.read(path), path.to_s)
    end

    def readout(piece, view = :structure, **options)
      Readout.new(piece).render(view, **options)
    end
  end
end
