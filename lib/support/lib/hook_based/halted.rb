# frozen_string_literal: true

module Support
  module HookBased
    # An error raised when a hook-based actor uses a special
    # halt failure code.
    class Halted < StandardError
      DEFAULT = "Something went wrong."

      attr_reader :input

      # @return [Symbol]
      attr_reader :reason

      def initialize(input)
        @input = input

        case input
        in Symbol => reason
          @reason = reason

          message = I18n.t(reason, scope: "dry_validation.errors.rules", default:)

          super(message)
        in String => message
          super(message)
        else
          super(default)
        end
      end

      def default
        DEFAULT
      end
    end
  end
end
