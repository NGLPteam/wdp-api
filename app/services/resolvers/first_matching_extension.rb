# frozen_string_literal: true

module Resolvers
  class FirstMatchingExtension < GraphQL::Schema::FieldExtension
    # @param [ActiveRecord::Relation, #first] value
    def after_resolve(value:, **)
      value.first
    end
  end
end
