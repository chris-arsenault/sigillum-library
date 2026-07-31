# frozen_string_literal: true

require "digest"
require "nokogiri"
require "pathname"
require "zip"

module Partitura
  module ScoreObservation
    class SourceReader
      MAX_DOCUMENT_BYTES = 512 * 1024 * 1024
      XML_EXTENSIONS = %w[.musicxml .xml].freeze

      Source = Struct.new(
        :format, :source_digest, :document_digest, :member, :xml,
        keyword_init: true
      ) do
        def to_h
          {
            format: format,
            source_digest: source_digest,
            document_digest: document_digest
          }.tap { |data| data[:member] = member if member }
        end
      end

      class << self
        def read(path)
          source_path = Pathname.new(path)
          raise Error.new("missing_score", "score does not exist: #{path}") unless source_path.file?

          bytes = source_path.binread
          extension = source_path.extname.downcase
          xml, format, member = if extension == ".mxl"
                                  read_mxl(source_path)
                                elsif XML_EXTENSIONS.include?(extension)
                                  [bytes, "musicxml", nil]
                                else
                                  raise Error.new(
                                    "unsupported_score_format",
                                    "expected .musicxml, .xml, or .mxl: #{path}"
                                  )
                                end
          validate_size!(xml)
          Source.new(
            format: format,
            source_digest: digest(bytes),
            document_digest: digest(xml),
            member: member,
            xml: xml
          )
        rescue Zip::Error => error
          raise Error.new("invalid_mxl", error.message), cause: error
        end

        def read_musicxml(value)
          xml = String(value).b
          validate_size!(xml)
          digest_value = digest(xml)
          Source.new(
            format: "musicxml",
            source_digest: digest_value,
            document_digest: digest_value,
            member: nil,
            xml: xml
          )
        end

        private

        def read_mxl(path)
          Zip::File.open(path) do |archive|
            container = archive.find_entry("META-INF/container.xml")
            raise Error.new("invalid_mxl", "MXL lacks META-INF/container.xml") unless container

            member = rootfile(container.get_input_stream.read)
            validate_member!(member)
            entry = archive.find_entry(member)
            raise Error.new("invalid_mxl", "MXL rootfile is absent: #{member}") unless entry
            raise Error.new("invalid_mxl", "MXL rootfile is encrypted: #{member}") if entry.encrypted?

            return [entry.get_input_stream.read, "mxl", member]
          end
        end

        def rootfile(container_xml)
          document = Nokogiri::XML(container_xml) { |config| config.strict.nonet }
          root = document.at_xpath(
            "/*[local-name()='container']/*[local-name()='rootfiles']/*[local-name()='rootfile']"
          )
          value = root&.[]("full-path")
          return value if value && !value.empty?

          raise Error.new("invalid_mxl", "MXL container does not declare a rootfile")
        rescue Nokogiri::XML::SyntaxError => error
          raise Error.new("invalid_mxl", "invalid MXL container: #{error.message}"), cause: error
        end

        def validate_member!(member)
          path = Pathname.new(member)
          return unless path.absolute? || path.each_filename.any? { |item| item == ".." }

          raise Error.new("unsafe_mxl", "MXL rootfile path is unsafe: #{member}")
        end

        def validate_size!(xml)
          return if xml.bytesize.positive? && xml.bytesize <= MAX_DOCUMENT_BYTES

          raise Error.new(
            "invalid_musicxml_size",
            "MusicXML document must contain 1..#{MAX_DOCUMENT_BYTES} bytes"
          )
        end

        def digest(value)
          "sha256:#{Digest::SHA256.hexdigest(value)}"
        end
      end
    end
  end
end
