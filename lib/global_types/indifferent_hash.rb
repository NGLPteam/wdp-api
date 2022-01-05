# frozen_string_literal: true

module GlobalTypes
  # Wrapper around a JSONB column that always provides an indifferent hash.
  #
  # It is available as `:indifferent_hash` through the type map.
  class IndifferentHash < ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb
    # Type cast a value from user input (e.g. from a setter).
    #
    # @param [Hash, #to_h] value
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def cast(value)
      Dry::Types["coercible.hash"].try(value).to_monad.value_or({}).with_indifferent_access
    end

    # Casts a value from database input to appropriate ruby type.
    #
    # @note Normal `ActiveRecord::Type` behavior is to pass nils through, but we *always* want a hash.
    # @param [Hash, #to_h] value
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def deserialize(value)
      cast(super)
    end

    # @api private
    # @note Compatibility method for ActiveRecord::Type
    # @return [Class]
    def accessor
      ActiveRecord::Store::IndifferentHashAccessor
    end
  end
end
