# frozen_string_literal: true

require "fileutils"
require "pathname"

module Partitura
  module Framework
    module Paths
      module_function

      ROOT = Pathname.new(ENV.fetch("PARTITURA_PROJECT_ROOT", Dir.pwd)).expand_path
      OUTPUTS = ROOT.join("outputs")
      MOVEMENT_OUTPUTS = OUTPUTS.join("movements")
      DSL_CARD_OUTPUTS = OUTPUTS.join("dsl_cards")
      AUDITION_OUTPUTS = OUTPUTS.join("auditions")
      REPORT_OUTPUTS = OUTPUTS.join("reports")
      SKETCH_OUTPUTS = OUTPUTS.join("sketches")

      def ensure_dir(path)
        path = Pathname.new(path.to_s)
        FileUtils.mkdir_p(path)
        path
      end

      def output_dir(*parts)
        ensure_dir(OUTPUTS.join(*parts.map(&:to_s)))
      end

      def movement_dir(stem)
        ensure_dir(MOVEMENT_OUTPUTS.join(stem.to_s))
      end

      def transport_path(out_dir, stem)
        Pathname.new(out_dir.to_s).join("#{stem}.partitura_transport.json")
      end
    end
  end
end
