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

      # @return [String]
      def query_builder_key
        schema_property? ? "props.*" : path
      end

      def schema_property?
        path.present? && path.starts_with?("props.")
      end
    end
  end
end
