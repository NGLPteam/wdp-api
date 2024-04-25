# frozen_string_literal: true

module Searching
  class CoreProperty < Dry::Struct
    include Dry::Core::Memoizable

    PATTERN = /\A\$core\.(?<path>.+)\z/

    attribute :path, Searching::Types::String
    attribute :static_property, Searching::Types::Instance(::StaticProperty)

    delegate :label, :description, :search_operators, :search_strategy, :type, to: :static_property

    # This is the path to use inside a database query
    # @return [String]
    def full_path
      "$#{path}$"
    end

    def search_path
      "$core.#{path}"
    end

    memoize def value_column
      EntitySearchableColumn.value_column_for_type value_type
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

    class << self
      def parse(input)
        case input
        when PATTERN
          path = Regexp.last_match[:path]

          prop = StaticProperty.find path

          new(path:, static_property: prop) if prop.present?
        end
      end
    end
  end
end
