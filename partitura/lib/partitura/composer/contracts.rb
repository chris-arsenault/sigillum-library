# frozen_string_literal: true

require_relative "operations"

module Partitura
  module Composer
    module Contracts
      PAGE = { "offset" => Schema.integer(min: 0, max: 100_000_000),
               "limit" => Schema.integer(max: 24_000) }.freeze
      PIECE = { "piece" => Schema::ID }.freeze
      REVISION = Schema.string("Use the revision returned by the latest read or save",
                               pattern: "^sha256:[0-9a-f]{64}$").freeze
      VIEWS = %w[ensemble_grid line verticals harmony_check exposed_clashes rhythm_profile
                 articulation_map recurrence_map range_check breath_map binding_check masking_report
                 spectrum_grid roughness_profile beat_salience ringing_grid melody_report controls].freeze
      DEFINITIONS = {
        "composer_start" => ["Start here: compositions, unfinished music and the short composer guide.",
                             Schema.object({})],
        "piece_adopt" => ["Preview adoption of an existing trusted local score without changing its music. " \
                          "Saving requires preview=false and the preview source_revision. Keeps its original path.",
                          Schema.object({ **PIECE, "brief" => Schema::TEXT, "preview" => { "type" => "boolean" },
                                          "source_revision" => REVISION }, required: %w[piece brief])],
        "piece_start" => ["Start a composition from its commission and forces. Then establish form and write music.",
                          Schema.object({ "id" => Schema::ID, "title" => Schema::TEXT, "brief" => Schema::TEXT,
                                          "meter" => Schema::METER, "key" => Schema::TEXT, "tempo" => Schema::TEXT,
                                          "parts" => Schema.array(Schema::PART, max: 128) },
                                        required: %w[id title brief])],
        "music_read" => ["Read actual written music and sounding ensemble context. Select section, passage or voice; " \
                         "omit them for form and opening music. Follow continuations before judging omitted music.",
                         Schema.object({ **PIECE, **PAGE, "section" => Schema::ID, "passage" => Schema::ID,
                                         "voice" => Schema::ID, "revision" => REVISION }, required: %w[piece])],
        "music_revise" => ["Save related musical edits together. Write explicit note lists; Partitura handles score " \
                           "construction and timing. Preview changes first if useful. Reread after a stale revision.",
                           Schema.object({ **PIECE, "revision" => REVISION,
                                           "changes" => Schema.array(Operations::SCHEMA, max: 256),
                                           "preview" => { "type" => "boolean" } },
                                         required: %w[piece revision changes])],
        "music_inspect" => ["Inspect sounding music from one musical angle. Default: ensemble grid for eight bars. " \
                            "Views provide evidence for musical judgment; they do not certify quality.",
                            Schema.object({ **PIECE, **PAGE, "view" => Schema.enum(*VIEWS), "part" => Schema::ID,
                                            "from_bar" => Schema.integer, "to_bar" => Schema.integer,
                                            "revision" => REVISION }, required: %w[piece])],
        "music_export" => ["Export local MusicXML and MIDI for notation and audition. Set draft=true to include " \
                           "explicitly reported unfinished music. Returns readable artifact resources.",
                           Schema.object({ **PIECE, "draft" => { "type" => "boolean" } }, required: %w[piece])],
        "composer_help" => ["Get focused help for the current composing task, notation, controls, instruments or a " \
                            "specific musical operation. No need to read every topic before composing.",
                            Schema.object({ "topic" => Schema.enum("compose", "revise", "notation", "form",
                                                                    "controls", "instruments", "projections"),
                                            "operation" => Schema.enum(*Operations::CONTRACTS.map do |item|
                                              item.fetch("properties").fetch("type").fetch("const")
                                            end) }, required: %w[topic])],
        "composer_reference" => ["Find craft guidance or cards by musical question. Read a returned reference " \
                                 "ID for its body; cards return musical content. Searching does not establish reading.",
                                 Schema.object({ **PAGE, "query" => Schema::TEXT, "reference" => Schema::TEXT })]
      }.freeze
      METHODS = { "composer_start" => :orient, "piece_start" => :start, "piece_adopt" => :adopt, "music_read" => :read,
                  "music_revise" => :revise, "music_inspect" => :inspect_music, "music_export" => :export,
                  "composer_help" => :help, "composer_reference" => :reference }.freeze

      module_function

      def tools
        DEFINITIONS.map do |name, (description, schema)|
          { name: name, description: description, inputSchema: schema,
            annotations: { readOnlyHint: !%w[piece_start piece_adopt music_revise music_export].include?(name),
                           destructiveHint: %w[piece_adopt music_revise].include?(name), openWorldHint: false } }
        end
      end

      def method_for(name, input)
        definition = DEFINITIONS[name]
        raise Error.new("unknown_tool", "No composer tool named #{name}.") unless definition

        Schema.validate!(input, definition.last)
        METHODS.fetch(name)
      end
    end
  end
end
