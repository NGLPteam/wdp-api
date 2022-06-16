# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      class Candidate
        include Dry::Effects.Resolve(:value_type)
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)
        include Dry::Initializer[undefined: false].define -> do
          param :accessor, Harvesting::Types.Instance(Harvesting::Metadata::ValueExtraction::Accessor)

          param :pipeline, Harvesting::Types::Callable, default: proc { Harvesting::Types::Identity }

          option :subtype, Harvesting::Metadata::ValueExtraction::Types::Type.optional

          option :set_id, Harvesting::Types::Identifier.optional, default: proc {}
          option :value_id, Harvesting::Types::Identifier
          option :full_path, Harvesting::Types::Path, default: proc { [set_id, value_id].compact.join(?.) }
        end
        include Harvesting::Metadata::ValueExtraction::GeneratesErrors
        include Shared::Typing

        # @param [Harvesting::Metadata::ExtractsValues] source
        # @return [Dry::Monads::Result]
        def call(source)
          input = yield accessor.call source

          output = yield wrap_pipeline(input)

          realized_type.try(output).to_monad
        end

        private

        # Compose the type from the parent `value` type
        # with this candidate's subtype (if provided).
        #
        # @return [Dry::Types::Type]
        def realized_type
          parent = value_type { Harvesting::Types::Any }

          return parent if subtype.blank?

          parent >> subtype
        end

        # @param [Object] input
        # @return [Dry::Monads::Result]
        def wrap_pipeline(input)
          output = pipeline.call input

          MonadHelpers.to_result output
        end
      end
    end
  end
end
