# frozen_string_literal: true

module Support
  module DryGQL
    class DefaultTypings
      extend Dry::Container::Mixin

      register "bool", Types::Params::Bool.set_gql_typing
      register "bigdecimal", ::Support::Types::BigDecimal.gql_type(:float)
      register "bigint", Types::Integer.gql_type(:bigint)
      register "date", Types::JSON::Date.set_gql_typing
      register "float", Types::Float.set_gql_typing
      register "integer", Types::Integer.set_gql_typing
      register "string", Types::String.set_gql_typing
      register "time", Types::JSON::Time.set_gql_typing
    end
  end
end
