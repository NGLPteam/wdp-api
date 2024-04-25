# frozen_string_literal: true

module Types
  # @abstract
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
end
