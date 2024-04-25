# frozen_string_literal: true

module Schemas
  module Orderings
    # The core configuration for an {Ordering}.
    class Definition
      include StoreModel::Model
      include Dry::Core::Equalizer.new(:id, inspect: false)

      # @!attribute [rw] id
      # A unique (within schema and entity) identifier
      # that represents the ordering. It is used when
      # fetching the ordering via the API.
      # @return [String]
      attribute :id, :string

      # @!attribute [rw] name
      # A human-readable name for this ordering.
      # @return [String]
      attribute :name, :string

      # @!attribute [rw] header
      # @return [String]
      attribute :header, :string

      # @!attribute [rw] footer
      # @return [String]
      attribute :footer, :string

      # @!attribute [rw] hidden
      # @return [Boolean]
      attribute :hidden, :boolean, default: proc { false }

      # @!attribute [rw] constant
      # Whether this ordering should be treated as unidirectional:
      # a "constant" ordering cannot be inverted. When calculating,
      # it will simply return the same position for inverse positions
      # as the default order.
      # @see #invertable?
      # @return [Boolean]
      attribute :constant, :boolean, default: proc { false }

      # @!attribute [rw] position
      # @return [Integer]
      attribute :position, :integer

      # @!attribute [r] filter
      # @return [Schemas::Orderings::FilterDefinition]
      attribute :filter, Schemas::Orderings::FilterDefinition.to_type, default: proc { {} }

      # @!attribute [r] handles
      # @return [Schemas::Associations::HandledSchema]
      attribute :handles, Schemas::Associations::HandledSchema.to_type, default: proc {}

      # @!attribute [r] order
      # @return [<Schemas::Orderings::OrderDefinition>]
      attribute :order, Schemas::Orderings::OrderDefinition.to_array_type, default: proc { [] }

      # @!attribute [r] render
      # @return [Schemas::Orderings::RenderDefinition]
      attribute :render, Schemas::Orderings::RenderDefinition.to_type, default: proc { {} }

      # @!attribute [r] select
      # @return [Schemas::Orderings::SelectDefinition]
      attribute :select, Schemas::Orderings::SelectDefinition.to_type, default: proc { {} }

      validates :id, :order, :select, presence: true

      validates :filter, :order, :render, :select, store_model: true

      validates :order, length: { minimum: 1, maximum: 7 }, unique_items: true

      delegate :covers_schema?, to: :filter
      delegate :tree_mode?, to: :render

      # @see Schemas::Associations::Association#find_schema_definition
      # @return [SchemaDefinition, nil]
      def handled_schema_definition
        return nil if handles.blank?

        handles.find_schema_definition
      end

      # Boolean complement of {#constant}
      def invertable?
        !constant?
      end

      # @!attribute [r] schema_position
      # @return [Integer, nil]
      def schema_position
        return position unless parent.kind_of?(Schemas::Versions::Configuration)

        position.presence || parent.orderings.index(self) + 1
      end

      # @!group Compilation

      # @see Schemas::Orderings::OrderBuilder::Compile
      # @return [Schemas::Ordering::OrderExpression]
      def compile_order_expression
        MeruAPI::Container["schemas.orderings.order_builder.compile"].call(self)
      end

      # @!endgroup
    end
  end
end
