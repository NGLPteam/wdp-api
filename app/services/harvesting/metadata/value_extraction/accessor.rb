# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @abstract
      class Accessor
        extend Dry::Core::ClassAttributes
        extend Dry::Initializer

        include Dry::Core::Memoizable
        include Dry::Monads[:result, :try]
        include Dry::Monads::Do.for(:call)
        include Harvesting::Metadata::ValueExtraction::GeneratesErrors

        error_context :accessor

        defines :source_type, type: Harvesting::Types::Type

        source_type Harvesting::Types::Any

        delegate :source_type, to: :class

        defines :swallow_exceptions, type: Harvesting::Types::Bool

        swallow_exceptions false

        # @param [Object] source
        # @return [Dry::Monads::Result]
        def call(source)
          source = yield validate_source source

          extracted = yield extract! source

          # Ensure we are returning a monad
          MonadHelpers.to_result extracted
        end

        # @abstract Define how this accessor gets at its value
        # @param [Object] source
        # @return [Object]
        def extract(source); end

        memoize def source_type
          self.class.source_type
        end

        def swallow_exceptions?
          self.class.swallow_exceptions
        end

        private

        # Call {#wrap_extraction} around {#extract}.
        #
        # @return [#to_monad]
        def extract!(source)
          wrap_extraction do
            extract source
          end
        end

        # @param [Object] source
        # @return [Dry::Monads::Result]
        def validate_source(source)
          source_type.try(source).to_monad.or do |message|
            return extraction_error!(:invalid_source, message:, source:)
          end
        end

        # Situationally wrap execution in a `Try` block if we {#swallow_exceptions?}.
        #
        # @return [#to_monad]
        def wrap_extraction
          return yield unless swallow_exceptions?

          Try do
            yield
          end.or do |exception|
            return Failure[:extraction_exception, exception]
          end
        end
      end
    end
  end
end
