# frozen_string_literal: true

module MusicXMLExporterHelpers
  def render_document(piece)
    REXML::Document.new(Partitura::Export::MusicXML.render(piece))
  end

  def text_at(document, path)
    REXML::XPath.first(document, path).text
  end

  def clef_signature(document, part_index)
    clef = REXML::XPath.first(document, "/score-partwise/part[#{part_index}]/measure[1]/attributes/clef")
    [REXML::XPath.first(clef, "sign")&.text, REXML::XPath.first(clef, "line")&.text]
  end

  def wedge_events(document)
    REXML::XPath.match(document, "//wedge").map do |element|
      { type: element.attributes["type"], number: Integer(element.attributes["number"]) }
    end
  end

  def child_element_names(element)
    element.elements.to_a.map(&:name)
  end

  def grand_staff_piece
    Partitura::Production.piece("Grand Staff Export") do
      meter "4/4"; key "C"; tempo "quarter = 96"
      roster do
        part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard, notation_group: :piano,
          notation_staff: 1
        part :piano_lower, "Piano Lower", music21: "Piano", family: :keyboard, notation_group: :piano,
          notation_staff: 2
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:upper, surface: :absolute) { events "C5:1 D5:1 E5:2" }
          phrase(:lower, surface: :absolute) { events "C3:2 G2:2" }
          placement :upper, part: :piano_upper, at: "bar 1 beat 1", role: :foreground
          placement :lower, part: :piano_lower, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end

  def single_part_piece(title, part_id, name, music21:, family:, event_text:, role: :foreground)
    Partitura::Production.piece(title) do
      meter "4/4"; key "C"
      roster { part part_id, name, music21: music21, family: family }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events event_text }
          placement :line, part: part_id, at: "bar 1 beat 1", role: role
        end
      end
    end
  end
end
