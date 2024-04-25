# frozen_string_literal: true

module Types
  # @abstract
  class BaseEnum < ::GraphQL::Schema::Enum
    include Support::GraphQLAPI::Enhancements::Enum
  end
end
