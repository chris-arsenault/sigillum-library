# frozen_string_literal: true

module Partitura
  module Production
    class GestureBuilder
      def initialize(id)
        @gesture = Gesture.new(id: id)
      end

      def build(&block)
        instance_eval(&block) if block
        @gesture
      end

      def idea(text)
        @gesture.idea_text = text
      end

      def mechanism(text)
        @gesture.add_mechanism(text)
      end

      def audible(text)
        @gesture.add_audible(text)
      end

      def line_relation(left, right, text)
        @gesture.add_line_relation(left, right, text)
      end

      def orchestration(text)
        @gesture.add_orchestration(text)
      end

      def silence(text)
        @gesture.add_silence(text)
      end

      def note(text)
        @gesture.add_note(text)
      end
    end

    class StaffBarBuilder
      def initialize(staff_bar)
        @staff_bar = staff_bar
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def check(text)
        @staff_bar.add_check(text)
      end

      def lane(role, text)
        @staff_bar.add_lane(role, text)
      end

      def method_missing(name, *args, &block)
        return super if block || args.length != 1

        lane(name, args.first)
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end
    end
  end
end
