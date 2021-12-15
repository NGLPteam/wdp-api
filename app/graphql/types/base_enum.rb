# frozen_string_literal: true

module Types
  class BaseEnum < GraphQL::Schema::Enum
    class << self
      def name_for_value(value)
        values.each_value.find do |enum|
          enum.value == value
        end&.graphql_name
      end
    end
  end
end
