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

      def schema_property?
        path.present? && path.starts_with?("props.")
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
      # This is the builder for a given order definition based on its
      # {#query_builder_key query builder key}.
      #
      # @see Schemas::Orderings::OrderBuilder
      # @return [#call]
      def query_builder
        Schemas::Orderings::OrderBuilder[query_builder_key]
      end

      # @!attribute [r] query_builder_key
      # The key used to look up the {#query_builder}.
      #
      # @api private
      # @return [String]
      def query_builder_key
        schema_property? ? "props.*" : path
      end

      # @!endgroup
    end
  end
end
