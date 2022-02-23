# frozen_string_literal: true

module Patches
  module ParseGraphQLJSON
    # @param [Object] value
    # @param [GraphQL::Query::Context] _context
    # @return [Object]
    def coerce_input(value, _context)
      case value
      when String
        JSON.parse(value)
      else
        value
      end
    rescue JSON::ParserError
      value
    end
  end
end

GraphQL::Types::JSON.singleton_class.prepend Patches::ParseGraphQLJSON
