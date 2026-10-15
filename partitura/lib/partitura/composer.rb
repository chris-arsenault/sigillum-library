# frozen_string_literal: true

require_relative "composer/store"
require_relative "composer/service"

module Partitura
  module Composer
    module_function

    def load_declaration(text)
      Engine.new(Score.new(JSON.parse(text))).build
    end
  end
end
