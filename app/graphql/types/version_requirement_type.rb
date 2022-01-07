# frozen_string_literal: true

module Types
  # @see GlobalTypes::VersionRequirement
  class VersionRequirementType < Types::BaseScalar
    description "A semantic version requirement"

    StringArray = Dry::Types["array"].of(Dry::Types["string"]).freeze

    class << self
      # @param [String, nil] input_value
      # @param [GraphQL::Query::Context] context
      # @return [Gem::Requirement]
      def coerce_input(input_value, context)
        case input_value
        when /[^,]+,[^,]+/
          Gem::Requirement.create input_value.split(/\s*,\s*/)
        when String, StringArray
          Gem::Requirement.create input_value
        when Gem::Requirement
          value
        else
          Gem::Requirement.default
        end
      rescue Gem::Requirement::BadRequirementError
        Gem::Requirement.default
      end

      # @param [Gem::Requirement] ruby_value
      # @param [GraphQL::Query::Context] context
      # @return [String]
      def coerce_result(ruby_value, context)
        case ruby_value
        when Gem::Requirement then ruby_value.to_s
        when String, StringArray then coerce_input(ruby_value, context).to_s
        end
      end
    end
  end
end
