# frozen_string_literal: true

module Schemas
  module Orderings
    # This object acts as a proxy for {Ordering} that can be provided
    # to {OrderingEntryCandidate.query_for}.
    #
    # @api private
    class Dynamic
      include Support::CallsCommonOperation
      include Dry::Initializer[undefined: false].define -> do
        option :definition, ::Schemas::Types.Instance(::Schemas::Orderings::Definition)

        option :entity, ::Schemas::Types::SchemaInstance

        option :id, ::Schemas::Types::String, default: proc { SecureRandom.uuid }
      end

      delegate :header, :footer, :covers_schema?, :tree_mode?, to: :definition

      delegate :schemas, allow_nil: true, to: "definition.filter", prefix: :filter

      # @api private
      # @see Schemas::Orderings::OrderBuilder::Compile
      def compile_ordering_expression
        call_operation("schemas.orderings.order_builder.compile", definition)
      end
    end
  end
end
