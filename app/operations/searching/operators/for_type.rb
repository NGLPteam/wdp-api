# frozen_string_literal: true

module Searching
  module Operators
    class ForType
      extend Dry::Core::Cache

      def call(type)
        type = type.to_s

        fetch_or_store type do
          [].tap do |operators|
            case type
            when "boolean"
              operators << "equals"
            when "date", "timestamp", "variable_date"
              operators << "date_equals"
              operators << "date_gte"
              operators << "date_lte"
            when "full_text", "markdown"
              operators << "matches"
            when "string"
              operators << "equals"
            when "select", "multiselect"
              operators << "equals"
              operators << "in_any"
            when "float", "integer"
              operators << "equals"
              operators << "numeric_gte"
              operators << "numeric_lte"
            end
          end
        end
      end
    end
  end
end
