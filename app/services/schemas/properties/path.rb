# frozen_string_literal: true

module Schemas
  module Properties
    class Path < Dry::Struct
      include Dry::Core::Equalizer.new(:path)
      include Dry::Core::Memoizable

      PREFIX = /\A(?<prefix>#{Schemas::Properties::Types::PATH_PART})\./

      attribute :path, Schemas::Properties::Types::FullPath

      attribute? :type, Schemas::Properties::Types::TypeName.fallback("unknown")

      alias full_path path

      # @!attribute [r] group
      # @return [String, nil]
      memoize def group
        path[PREFIX, :prefix]
      end

      memoize def search_strategy
        case type
        when "full_text", "markdown" then "text"
        when "variable_date" then "named_variable_date"
        else
          "property"
        end
      end

      memoize def value_column
        EntitySearchableProperty.value_column_for_type value_type
      end

      memoize def value_type
        case type
        when "boolean" then :boolean
        when "date", "timestamp", "variable_date" then :date
        when "email", "select", "string" then :text
        when "integer" then :integer
        when "float" then :float
        when "multiselect" then :text_array
        end
      end
    end
  end
end
