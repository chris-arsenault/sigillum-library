# frozen_string_literal: true

require "cgi"

module Partitura
  module Export
    module MusicXML
      class Builder
        def initialize
          @lines = []
          @indent = 0
        end

        def raw(text)
          @lines << text
        end

        def comment(text)
          @lines << "#{'  ' * @indent}<!--#{text}-->"
        end

        def open(name, attrs = {})
          @lines << "#{'  ' * @indent}<#{name}#{attributes(attrs)}>"
          @indent += 1
        end

        def close(name)
          @indent -= 1
          @lines << "#{'  ' * @indent}</#{name}>"
        end

        def element(name, text = nil, attrs = {})
          if text.nil?
            empty(name, attrs)
          else
            @lines << "#{'  ' * @indent}<#{name}#{attributes(attrs)}>#{escape_text(text)}</#{name}>"
          end
        end

        def empty(name, attrs = {})
          @lines << "#{'  ' * @indent}<#{name}#{attributes(attrs)} />"
        end

        def to_s
          "#{@lines.join("\n")}\n"
        end

        private

        def attributes(attrs)
          return "" if attrs.empty?

          attrs.map { |key, value| %( #{key}="#{escape_attr(value)}") }.join
        end

        def escape_text(value)
          CGI.escapeHTML(value.to_s)
        end

        def escape_attr(value)
          CGI.escapeHTML(value.to_s)
        end
      end
    end
  end
end
