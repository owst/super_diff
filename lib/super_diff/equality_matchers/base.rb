module SuperDiff
  module EqualityMatchers
    class Base
      def self.call(expected, actual)
        new(expected, actual).call
      end

      def initialize(expected, actual)
        @expected = expected
        @actual = actual
      end

      def call
        if expected == actual
          ""
        else
          fail
        end
      end

      protected

      attr_reader :expected, :actual

      def fail
        raise NotImplementedError
      end
    end
  end
end
