# frozen_string_literal: true

module Harvesting
  module Options
    # @api private
    class Mapping
      include StoreModel::Model
      include Shared::EnhancedStoreModel

      attribute :link_identifiers_globally, :boolean, default: false
    end
  end
end
