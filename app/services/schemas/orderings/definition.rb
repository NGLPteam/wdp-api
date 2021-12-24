# frozen_string_literal: true

module Schemas
  module Orderings
    class Definition
      include StoreModel::Model
      include Dry::Core::Equalizer.new(:id, inspect: false)

      attribute :id, :string
      attribute :name, :string
      attribute :header, :string
      attribute :footer, :string
      attribute :hidden, :boolean, default: proc { false }
      attribute :constant, :boolean, default: proc { false }

      attribute :order, Schemas::Orderings::OrderDefinition.to_array_type, default: proc { [] }
      attribute :select, Schemas::Orderings::SelectDefinition.to_type, default: proc { {} }
      attribute :filter, Schemas::Orderings::FilterDefinition.to_type, default: proc { {} }

      validates :id, :order, :select, presence: true

      validates :select, :filter, :order, store_model: true

      validates :order, length: { minimum: 1, maximum: 7 }, unique_items: true
    end
  end
end
