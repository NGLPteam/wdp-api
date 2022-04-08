# frozen_string_literal: true

module Schemas
  module Properties
    # @api private
    # @see Schemas::Properties::ParsePath
    class InvalidPath < Dry::Struct
      include Dry::Monads[:result]

      attribute :input, Schemas::Properties::Types::Any
      attribute :reason, Schemas::Properties::Types::String

      # @return [Dry::Monads::Failure(:unparseable, Schemas::Properties::InvalidPath)]
      def to_monad
        Failure[:unparseable, self]
      end

      alias to_result to_monad
    end
  end
end
