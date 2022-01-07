# frozen_string_literal: true

module GlobalTypes
  # Wrapper around a `Gem::Requirement`.
  #
  # This service is intended for use with StoreModel,
  class VersionRequirement < ActiveRecord::Type::String
    # A dry.rb type matcher for an array of strings.
    StringArray = Dry::Types["array"].of(Dry::Types["string"]).freeze

    private_constant :StringArray

    # Type cast a value from user input (e.g. from a setter).
    #
    # @param [String, <String>, Gem::Requirement] value
    # @return [Gem::Requirement]
    def cast(value)
      case value
      when /[^,]+,[^,]+/
        Gem::Requirement.create value.split(/\s*,\s*/)
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

    # @param [Gem::Requirement] value
    # @return [<String>]
    def serialize(value)
      case value
      when Gem::Requirement
        value.as_list
      else
        []
      end
    end

    alias serialize_for_store_model serialize

    # @!attribute [r] type
    # @return [:version_requirement]
    def type
      :version_requirement
    end
  end
end
