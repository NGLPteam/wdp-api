# frozen_string_literal: true

module Patches
  # We use `Dry::Core::Equalizer` on some of our store model attributes
  # in order to provide uniqueness validations. This conflicts with some
  # mutation tracking for StoreModel, so we need to make it compare by
  # JSON value rather than rely on the `==` on the object itself.
  module AlterStoreModelMutationTracking
    # @param [String] raw_old_value
    # @param [StoreModel::Model] new_value
    def changed_in_place?(raw_old_value, new_value)
      cast_value(raw_old_value).as_json != new_value.as_json
    end
  end
end

StoreModel::Types::ManyBase.prepend Patches::AlterStoreModelMutationTracking
StoreModel::Types::OneBase.prepend Patches::AlterStoreModelMutationTracking
