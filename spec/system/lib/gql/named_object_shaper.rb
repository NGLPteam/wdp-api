# frozen_string_literal: true

module Testing
  module GQL
    class NamedObjectShaper
      include BuildableObject

      extend Dry::Initializer

      param :name, Dry::Types["coercible.string"]

      def compile
        {
          name => body.to_h
        }.deep_symbolize_keys
      end
    end
  end
end
