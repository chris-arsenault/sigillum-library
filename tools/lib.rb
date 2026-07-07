#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).parent.expand_path
CARD_ROOT = ROOT / "technique_library" / "dsl" / "cards"
MANIFEST = CARD_ROOT / "manifest.json"

FACETS = {
  "lead" => %w[melody lead cantabile tune theme sing crown soprano declaim recit melodic duet],
  "comp" => ["comp", "accompan", "background", "pad", "oom", "after-beat", "afterbeat",
             "vamp", "support", "chord-pump", "chordal accompan"],
  "counter" => ["counter", "inner voice", "inner line", "dialogue", "answer", "call-and-response",
                "call and response", "interplay", "relay", "gap", "hocket", "trade", "antiphon",
                "obbligato", "conversation", "heterophon", "duet", "caller", "repeater"],
  "bass" => %w[bass walking ground pedal ostinato floor root-5th oom-bass drone],
  "rhythm" => ["rhythm", "syncopat", "charleston", "pulse", "groove", "16th", "off-beat",
               "offbeat", "dotted", "hemiola", "cross-rhythm", "stutter", "drive", "driving",
               "motor", "pump", "comped", "2-against-3", "displace", "push", "anticipat",
               "regroup", "3+3+2"],
  "voicing" => ["voicing", "chord", "spacing", "rootless", "drop-2", "drop2", "inversion",
                "quartal", "close position", "open spac", "spread", "upper-structure",
                "upper structure", "tertian", "10th", "guide tone", "so what", "clump"],
  "color" => ["pizz", "sul pont", "sul tasto", "tremolo", "trem", "col legno", "harmonic",
              "timbre", "articulat", "bariolage", "strum", "flautando", "gliss", "scordatura",
              "locked hands", "l.v.", "una corda", "celesta", "music-box", "bell", "sul ",
              "trill"],
  "figuration" => ["figuration", "arpegg", "run", "flourish", "scalar", "broken", "toccata",
                   "oscillat", "neighbor", "passage", "filigree", "current", "double-third",
                   "compound melody", "murky", "cadenza", "weave", "ornament", "parallel",
                   "crosshand", "cross-hand", "sweep", "cascade", "waterfall", "rocking",
                   "gesture"],
  "tender" => ["romance", "tender", "lyric", "dolce", "gentle", "calm", "luminous", "halo",
               "nocturne", "serenade", "love", "warm", "ballad", "planed 9th", "haze",
               "beloved"],
  "tension" => ["menac", "tension", "drive", "driving", "battle", "agitat", "sinister",
                "cold", "dread", "storm", "villain", "adversary", "anxious", "biting",
                "hammer", "tritone", "film", "scherz", "fff", "climax"],
  "grief" => %w[grief lament elegy decay dissolv mourn funeral sorrow poison dark],
  "section" => ["tutti", "section", "ensemble", "choir", "chorale", "antiphon", "unison",
                "massed", "desk", "block", "fff_pyramid", "pyramid", "two choirs", "strata"]
}.freeze

ROLE_DIMS = [
  ["ROLE", %w[lead comp counter bass]],
  ["INTEREST", %w[rhythm voicing color figuration]],
  ["CHARACTER", %w[tender tension grief]],
  ["ENSEMBLE", %w[section]]
].freeze

def manifest
  abort "missing DSL card manifest: #{MANIFEST.relative_path_from(ROOT)}" unless MANIFEST.exist?

  JSON.parse(MANIFEST.read)
end

def facets_of(card)
  haystack = "#{card.fetch("behavior", "")} #{card.fetch("name")}".downcase
  FACETS.each_key.select do |facet|
    FACETS.fetch(facet).any? { |keyword| haystack.include?(keyword) }
  end
end

def surfaces_of(card)
  card.fetch("parts", []).filter_map { |part| part["surface"] }.uniq.sort
end

def dsl_ref(card)
  "dsl:#{card.fetch("category")}/#{card.fetch("name")}"
end

def dsl_path(card)
  Pathname.new(card.fetch("path"))
end

def card_summary(card)
  surfaces = surfaces_of(card)
  bits = []
  bits << "#{card.fetch("bars", "?")}b"
  bits << card.fetch("meter", "4/4").to_s
  bits << card.fetch("key", "").to_s unless card.fetch("key", "").to_s.empty?
  bits << "q=#{card["tempo"] || "?"}"
  bits << "cite #{card["cite"]}" unless card.fetch("cite", "").to_s.empty?
  bits << "surfaces #{surfaces.join(",")}" unless surfaces.empty?
  bits.join("; ")
end

def usage
  <<~TEXT
    lib -- production-DSL technique library lookup

    Usage:
      ruby tools/lib.rb <term>        # category or derived facet search
      ruby tools/lib.rb show <NAME>   # card metadata + DSL specimen path
      ruby tools/lib.rb show dsl:<category>/<NAME>
      ruby tools/lib.rb terms         # categories + facets
  TEXT
end

def category_match?(term, category)
  category == term || (term == "orchestration" && category.start_with?("orch."))
end

def search(term)
  cards = manifest
  normalized = term.downcase.strip
  hits = matching_cards(cards, normalized)

  if hits.empty?
    puts "no cards for '#{term}'. valid terms:"
    return terms
  end

  puts "#{hits.length} card(s) for '#{term}':"
  puts
  hits.each { |card| print_search_hit(card) }
end

def matching_cards(cards, normalized)
  cards.select do |card|
    category_match?(normalized, card.fetch("category")) || facets_of(card).include?(normalized)
  end
end

def print_search_hit(card)
  behavior = truncated_behavior(card.fetch("behavior", ""))
  surfaces = surfaces_of(card).join(",")
  puts "  %-24s [%s] {%s}" % [card.fetch("name"), card.fetch("category"), facets_of(card).sort.join(",")]
  puts "      #{dsl_ref(card)} -> #{dsl_path(card)}"
  puts "      surfaces: #{surfaces}" unless surfaces.empty?
  puts "      #{behavior}" unless behavior.empty?
end

def truncated_behavior(behavior)
  behavior.length > 96 ? "#{behavior[0, 96]}..." : behavior
end

def find_card(name)
  text = name.to_s
  if (match = text.match(%r{\Adsl:([^/]+)/(.+)\z}))
    category = match[1]
    card_name = match[2]
    return manifest.find { |card| card.fetch("category") == category && card.fetch("name").casecmp?(card_name) }
  end

  manifest.find { |card| card.fetch("name").casecmp?(text) }
end

def show(name)
  card = find_card(name)
  unless card
    puts "no card named #{name}"
    return
  end

  facets = facets_of(card).sort.join(",")
  puts "#{card.fetch("name")}  [#{card.fetch("category")}] {#{facets}}  (#{card_summary(card)})"
  puts "DSL REF: #{dsl_ref(card)}"
  puts "DSL SPECIMEN: #{dsl_path(card)}"
  puts
  puts "BEHAVIOR: #{card.fetch("behavior", "")}"
  puts
  puts "PARTS:"
  card.fetch("parts", []).each do |part|
    surface = part["surface"] || "?"
    puts "  #{part.fetch("id")} - #{part.fetch("name")} (#{part.fetch("instrument")}) surface=#{surface}"
  end
  puts
  puts "Read the Ruby DSL specimen for auditionable notes and representation."
end

def terms
  categories = manifest.map { |card| card.fetch("category") }.uniq.sort
  orch = categories.select { |category| category.start_with?("orch.") }
  flat = categories - orch

  puts "CATEGORIES (axis 1 -- route by instrument/role):"
  puts "  #{flat.join("  ")}"
  unless orch.empty?
    puts "  orchestration  ->  #{orch.join("  ")}"
    puts "    parent 'orchestration' spans all orch.* families"
  end
  puts
  puts "FACETS (axis 2 -- derived from card behavior):"
  ROLE_DIMS.each do |label, facets|
    puts "  %-12s %s" % [label, facets.join("  ")]
  end
end

def main(argv)
  if argv.empty?
    puts usage
  elsif argv[0] == "show" && argv[1]
    show(argv[1])
  elsif %w[terms list help].include?(argv[0])
    terms
  else
    search(argv[0])
  end
end

main(ARGV)
