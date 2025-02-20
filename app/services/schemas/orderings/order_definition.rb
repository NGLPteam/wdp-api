# frozen_string_literal: true

module Schemas
  module Orderings
    class OrderDefinition
      include StoreModel::Model
      include Dry::Core::Equalizer.new(:path, inspect: false)

      attribute :path, :string

      attribute :constant, :boolean, default: proc { false }

      attribute :direction, :string, default: "asc"

      attribute :nulls, :string, default: "last"

      validates :direction, presence: true, inclusion: { in: %w[asc desc] }
      validates :nulls, presence: true, inclusion: { in: %w[last first] }
      validates :path, presence: true, format: { with: Schemas::Orderings::OrderBuilder::PATTERN }

      def constant?
        constant.present?
      end

      def asc?
        direction == "asc"
      end

      def desc?
        direction == "desc"
      end

      def nulls_first?
        nulls == "first"
      end

      def nulls_last?
        nulls == "last"
      end

      # @!group Compilation

      # @api private
      # @see #query_builder
      # @note This method should only be called within {Schemas::Orderings::OrderBuilder::Compile the compilation process}.
      # @param [{ Symbol => Object }] options
      # @return [<Arel::Nodes::Ordering>]
      def compile(**options)
        query_builder.call self, **options
      end

      # @!attribute [r] query_builder
      # This is the builder for a given order definition.
      #
      # @see Schemas::Orderings::OrderBuilder::Build
      # @return [Schemas::Orderings::OrderBuilder::Base]
      def query_builder
        MeruAPI::Container["schemas.orderings.order_builder.build"].(path)
      end

      # @!endgroup
    end
  end
end
