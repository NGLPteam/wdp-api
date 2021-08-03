# frozen_string_literal: true

module Schemas
  module Orderings
    class SelectLinkDefinition
      include StoreModel::Model

      attribute :contained, :boolean, default: proc { false }
      attribute :referenced, :boolean, default: proc { false }
    end
  end
end
