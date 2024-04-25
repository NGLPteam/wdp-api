# frozen_string_literal: true

module Support
  # A relaxed dry-struct that accepts stringified keys,
  # and will apply defaults when explicitly passed `nil`
  # on keys where applicable.
  #
  # @abstract
  class FlexibleStruct < Dry::Struct
    transform_keys(&:to_sym)

    transform_types do |type|
      if type.default?
        type.constructor do |value|
          value.nil? ? Dry::Types::Undefined : value
        end
      else
        type
      end
    end

    def slice(*keys)
      keys.flatten.index_with { public_send _1 }
    end
  end
end
