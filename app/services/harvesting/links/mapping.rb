# frozen_string_literal: true

module Harvesting
  module Links
    class Mapping
      include StoreModel::Model

      attribute :incoming_collections, Harvesting::Links::Source.to_array_type, default: proc { [] }
    end
  end
end
