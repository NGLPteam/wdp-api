# frozen_string_literal: true

module Schemas
  module Orderings
    class FilterDefinition
      include StoreModel::Model

      DIRECT = %w[none children descendants].freeze

      attribute :direct, :string, default: "children"
      attribute :links, Schemas::Orderings::SelectLinkDefinition.to_type, default: proc { {} }

      validates :children, presence: true, inclusion: { in: DIRECT }
    end
  end
end
