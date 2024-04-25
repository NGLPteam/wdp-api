# frozen_string_literal: true

module Support
  module NormalizedGQL
    class Field < Dry::Struct
      attribute :name, Dry::Types["coercible.symbol"]
      attribute :type, Dry::Types["string"]
      attribute :null, Dry::Types["bool"]

      # @return [String]
      def to_field_definition
        <<~RUBY.strip.indent(4)
        field #{name.inspect}, #{type}, null: #{null} do
          description <<~TEXT
          TEXT
        end
        RUBY
      end
    end
  end
end
