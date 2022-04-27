# frozen_string_literal: true

module Harvesting
  module Options
    # @api private
    class List
      include StoreModel::Model
      include Shared::EnhancedStoreModel
    end
  end
end
