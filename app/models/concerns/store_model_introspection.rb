# frozen_string_literal: true

# Helper methods for inspecting and working with `StoreModel` attributes.
module StoreModelIntrospection
  extend ActiveSupport::Concern

  included do
    delegate :store_model_attribute_names, to: :class
  end

  # Fetch a hash of only store model attributes for manipulation and introspection.
  # @return [ActiveSupport:HashWithIndifferentAccess{ String, Symbol => StoreModel::Model }]
  def store_model_attributes
    store_model_attribute_names.index_with do |name|
      public_send(name)
    end.with_indifferent_access
  end

  class_methods do
    # @!attribute [r] store_model_attribute_names
    # @return [<String>]
    def store_model_attribute_names
      store_model_attribute_types.keys
    end

    # @!attribute [r] store_model_attribute_types
    # @return [{ String => StoreModel::Type::One, StoreModel::Type::Many }]
    def store_model_attribute_types
      @store_model_attribute_types ||= attribute_types.select { |_, v| v.kind_of?(StoreModel::Types::One) || v.kind_of?(StoreModel::Types::Many) }
    end
  end
end
