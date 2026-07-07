# frozen_string_literal: true

require_relative "partitura/marks"
require_relative "partitura/model"
require_relative "partitura/parser"
require_relative "partitura/builders"
require_relative "partitura/projections"
require_relative "partitura/surface_lab"
require_relative "partitura/jit_docs"
require_relative "partitura/production"
require_relative "partitura/guided"
require_relative "partitura/export"

module Partitura
  module_function

  def piece(title, &block)
    PieceBuilder.new(title).build(&block)
  end

  def load_file(path)
    context = Object.new
    context.define_singleton_method(:piece) do |title, &block|
      Partitura.piece(title, &block)
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

  def production_transport_metrics(piece_or_transport)
    if piece_or_transport.is_a?(Hash)
      Production::TransportMetrics.new(piece_or_transport).to_h
    else
      Production::TransportMetrics.for_piece(piece_or_transport).to_h
    end
  end

  def production_melody_analysis(piece, **options)
    Production::MelodyAnalysis.for_piece(piece, **options).to_h
  end

  def production_musicxml_import(path, **options)
    Production::MusicXMLImport.convert(path, **options)
  end

  def production_musicxml_import_verify(hand_path, export_path, **options)
    Production::MusicXMLImport.verify(hand_path, export_path, **options)
  end

  def production_musicxml(piece_or_transport)
    transport = piece_or_transport.is_a?(Hash) ? piece_or_transport : production_transport_hash(piece_or_transport)
    Export::MusicXML.render(transport)
  end

  def production_midi(piece_or_transport)
    transport = piece_or_transport.is_a?(Hash) ? piece_or_transport : production_transport_hash(piece_or_transport)
    Export::MIDI.render(transport)
  end
end
