# frozen_string_literal: true

module Schemas
  module Edges
    class Calculate
      extend Dry::Core::Cache

      include Dry::Monads[:result, :try]

      # @param [String, Object] parent (@see Schemas::Types::Kind)
      # @param [String, Object] child (@see Schemas::Types::Kind)
      # @return [Dry::Monads::Success(Schemas::Edges::Edge)]
      # @return [Dry::Monads::Failure(:unacceptable_edge, Schemas::Edges::Invalid)]
      def call(parent, child)
        parent = Schemas::Types::Kind[parent]

        child = Schemas::Types::Kind[child]

        fetch_or_store parent, child do
          Schemas::Edges::Calculator.new(parent, child).call
        end
      rescue Dry::Struct::Error, Dry::Types::ConstraintError
        raise Schemas::Edges::Incomprehensible.new(parent, child)
      end
    end
  end
end
