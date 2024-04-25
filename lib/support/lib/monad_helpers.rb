# frozen_string_literal: true

module Support
  module MonadHelpers
    class ToMaybe
      include Dry::Monads[:maybe]

      def call(obj)
        return obj if obj.kind_of?(Dry::Monads::Maybe)

        return obj.to_monad.to_maybe if obj.respond_to?(:to_monad)

        Maybe(obj)
      end
    end

    class ToResult
      include Dry::Monads[:result]

      TO_RESULTABLE_KINDS = [
        Dry::Monads::Maybe,
        Dry::Monads::Result,
        Dry::Monads::Try,
        Dry::Monads::Validated,
      ].freeze

      def call(obj)
        return obj if obj.kind_of?(Dry::Monads::Result)

        return obj.to_result if can_trust_to_result?(obj)

        return obj.to_monad.to_result if obj.respond_to?(:to_monad)

        Success obj
      end

      def can_trust_to_result?(obj)
        TO_RESULTABLE_KINDS.any? do |kind|
          kind === obj
        end
      end
    end

    class ToValidated
      include Dry::Monads[:validated]

      def call(obj)
        return obj if obj.kind_of?(Dry::Monads::Validated)

        return obj.to_monad.to_validated if obj.respond_to?(:to_monad)

        Valid(obj)
      end
    end

    class << self
      def to_maybe(obj)
        ToMaybe.new.call(obj)
      end

      def to_result(obj)
        ToResult.new.call(obj)
      end

      def to_validated(obj)
        ToValidated.new.call(obj)
      end
    end
  end
end
