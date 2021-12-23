# frozen_string_literal: true

module GlobalTypes
  # Wrapper around a `Gem::Requirement`
  class VersionRequirement < ActiveRecord::Type::String
    StringArray = Dry::Types["array"].of(Dry::Types["string"]).freeze

    # Type cast a value from user input (e.g. from a setter).
    #
    # @param [Hash, #to_h] value
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def cast(value)
      case value
      when String, StringArray
        Gem::Requirement.create value
      when Gem::Requirement
        value
      else
        Gem::Requirement.default
      end
    rescue Gem::Requirement::BadRequirementError
      Gem::Requirement.default
    end

    def serialize(value)
      case value
      when Gem::Requirement
        value.as_list
      else
        []
      end
    end

    alias serialize_for_store_model serialize

    def type
      :version_requirement
    end
  end
end
