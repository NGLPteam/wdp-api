# frozen_string_literal: true

module Schemas
  module Orderings
    class OrderDefinition
      include StoreModel::Model
      include Dry::Core::Equalizer.new(:path, inspect: false)

      attribute :path, :string

      attribute :direction, :string, default: "asc"

      attribute :nulls, :string, default: "last"

      validates :direction, presence: true, inclusion: { in: %w[asc desc] }
      validates :nulls, presence: true, inclusion: { in: %w[last first] }
      validates :path, presence: true

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
    end
  end
end
