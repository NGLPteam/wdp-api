# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      class Error < Dry::Struct
        include Dry::Monads[:result]

        MetadataMap = Harvesting::Types::Hash.map(Harvesting::Types::Coercible::Symbol, Harvesting::Types::Any).default { {} }

        attribute :code, Harvesting::Types::Identifier
        attribute :context, Harvesting::Types::Identifier
        attribute? :message, Harvesting::Types::String.optional
        attribute :metadata, MetadataMap

        # @return [Dry::Monads::Failure(Symbol, Harvesting::Metadata::ValueExtraction::Error)]
        def to_monad
          Failure[code, self]
        end

        alias to_result to_monad
      end
    end
  end
end
