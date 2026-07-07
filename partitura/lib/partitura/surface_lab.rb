# frozen_string_literal: true

module Partitura
  module SurfaceLab
    class Record
      attr_reader :kind, :id, :attrs, :fields

      def initialize(kind, id = nil, attrs = {})
        @kind = kind.to_sym
        @id = id.respond_to?(:to_sym) ? id.to_sym : id
        @attrs = attrs
        @fields = []
      end

      def add_field(name, value)
        @fields << [name.to_sym, value]
      end

      def field(name)
        found = @fields.find { |field_name, _| field_name == name.to_sym }
        found && found[1]
      end
    end

    class Study
      attr_reader :title, :family, :bars, :records

      def initialize(title, family:, bars:)
        @title = title
        @family = family.to_sym
        @bars = bars
        @records = []
      end

      def add(record)
        @records << record
        record
      end

      def records_of(kind)
        @records.select { |record| record.kind == kind.to_sym }
      end
    end

    class Builder
      def initialize(title, family:, bars:)
        @study = Study.new(title, family: family, bars: bars)
      end

      def build(&block)
        instance_eval(&block) if block
        @study
      end

      def meter(value, beat_pattern: nil)
        record(:meter, nil, value: value, beat_pattern: beat_pattern)
      end

      def key(value, mode: nil)
        record(:key, nil, value: value, mode: mode)
      end

      def parts(*ids)
        record(:parts, nil, ids: ids.map(&:to_sym))
      end

      def section(id, name, bars:, &block)
        scoped_record(:section, id, name: name, bars: bars, &block)
      end

      def phrase(id, **attrs, &block)
        scoped_record(:phrase, id, attrs, &block)
      end

      def line(part_id, role:, bars: nil, **attrs, &block)
        scoped_record(:line, part_id, attrs.merge(role: role, bars: bars), &block)
      end

      def staff_bar(number, **attrs, &block)
        scoped_record(:staff_bar, number, attrs, &block)
      end

      def placement(phrase_id, part:, at:, **attrs, &block)
        rec = record(:placement, phrase_id, attrs.merge(part: part, at: at))
        FieldBuilder.new(rec).build(&block) if block
        rec
      end

      def note(text)
        record(:note, nil, text: text)
      end

      private

      def scoped_record(kind, id, attrs = {}, &block)
        rec = record(kind, id, attrs)
        FieldBuilder.new(rec).build(&block) if block
        rec
      end

      def record(kind, id = nil, attrs = {})
        @study.add(Record.new(kind, id, attrs))
      end
    end

    class FieldBuilder
      def initialize(record)
        @record = record
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def field(name, value)
        @record.add_field(name, value)
      end

      def method_missing(name, *args, **kwargs, &block)
        return super if block

        value =
          if kwargs.empty?
            args.length == 1 ? args.first : args
          elsif args.empty?
            kwargs
          else
            { values: args, options: kwargs }
          end
        field(name, value)
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end
    end

    class Readout
      def initialize(study)
        @study = study
      end

      def summary
        lines = []
        lines << "# #{@study.title}"
        lines << "family: #{@study.family}"
        lines << "bars: #{@study.bars.begin}-#{@study.bars.end}"
        meter = @study.records_of(:meter).first
        key = @study.records_of(:key).first
        lines << "meter: #{meter.attrs[:value]} #{meter.attrs[:beat_pattern].inspect}" if meter
        lines << "key: #{key.attrs[:value]}#{key.attrs[:mode] ? " / #{key.attrs[:mode]}" : ""}" if key
        lines << ""
        %i[section phrase line staff_bar placement].each do |kind|
          count = @study.records_of(kind).length
          lines << "#{kind}s: #{count}"
        end
        lines.join("\n")
      end

      def structure
        lines = [summary, "", "## Sections"]
        @study.records_of(:section).each do |section|
          lines << "- #{section.id}: #{section.attrs[:name]} bars #{range_label(section.attrs[:bars])}"
        end
        lines << ""
        lines << "## Phrases"
        @study.records_of(:phrase).each do |phrase|
          lines << "- #{phrase.id}: #{phrase.attrs}"
          phrase.fields.each { |name, value| lines << "  #{name}: #{compact(value)}" }
        end
        lines << ""
        lines << "## Lines"
        @study.records_of(:line).each do |line|
          lines << "- #{line.id}: role #{line.attrs[:role]} bars #{range_label(line.attrs[:bars])}"
          line.fields.each { |name, value| lines << "  #{name}: #{compact(value)}" }
        end
        lines.join("\n")
      end

      def bars
        lines = [summary, "", "## Bar Surface"]
        @study.records_of(:staff_bar).each do |bar|
          lines << "bar #{bar.id}:"
          bar.fields.each { |name, value| lines << "  #{name}: #{compact(value)}" }
        end
        lines.join("\n")
      end

      def placements
        lines = [summary, "", "## Placements"]
        @study.records_of(:placement).each do |placement|
          lines << "- #{placement.id} -> #{placement.attrs[:part]} at #{placement.attrs[:at]} #{placement.attrs}"
          placement.fields.each { |name, value| lines << "  #{name}: #{compact(value)}" }
        end
        lines.join("\n")
      end

      private

      def range_label(range)
        return "" unless range

        "#{range.begin}-#{range.end}"
      end

      def compact(value)
        text = value.inspect
        text.length > 180 ? "#{text[0, 177]}..." : text
      end
    end

    module_function

    def study(title, family:, bars:, &block)
      Builder.new(title, family: family, bars: bars).build(&block)
    end

    def load_file(path)
      context = Object.new
      context.define_singleton_method(:surface_study) do |title, family:, bars:, &block|
        SurfaceLab.study(title, family: family, bars: bars, &block)
      end
      context.instance_eval(File.read(path), path.to_s)
    end

    def readout(study, view = :structure)
      reader = Readout.new(study)
      case view.to_sym
      when :summary
        reader.summary
      when :structure
        reader.structure
      when :bars
        reader.bars
      when :placements
        reader.placements
      else
        raise ArgumentError, "unknown surface-lab view #{view.inspect}"
      end
    end
  end
end
