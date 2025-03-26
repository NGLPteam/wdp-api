# frozen_string_literal: true

module Metadata
  module Shared
    module Xsd
      class NonNegativeInteger < Lutaml::Model::Type::String
        PATTERN = /\A(?-mix:\+?[0-9]+)\z/

        class << self
          def cast(value)
            return nil if value.nil?

            value = super

            raise Lutaml::Model::Type::InvalidValueError, "The value #{value} does not match the required pattern: #{PATTERN}" unless value.match?(PATTERN)

            value.to_i
          end
        end
      end
    end
  end
end
