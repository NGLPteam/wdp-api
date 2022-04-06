# frozen_string_literal: true

module Shared
  # StoreModel is missing a few nice things from ActiveModel,
  # like validation callbacks, and the ability to use brackets
  # to access attributes.
  module EnhancedStoreModel
    extend ActiveSupport::Concern

    included do
      include StoreModel::Model
      include ActiveModel::Validations::Callbacks
    end

    # @param [#to_s] attr
    # @return [Object]
    def [](attr)
      public_send(attr)
    end

    # @param [#to_s] attr
    # @param [Object]
    # @return [void]
    def []=(attr, value)
      public_send(:"#{attr}=", value)
    end
  end
end
