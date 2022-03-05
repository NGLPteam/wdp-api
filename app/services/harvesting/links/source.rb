# frozen_string_literal: true

module Harvesting
  module Links
    class Source
      include StoreModel::Model

      attribute :identifier, :string

      attribute :operator, :string, default: "contains"
    end
  end
end
