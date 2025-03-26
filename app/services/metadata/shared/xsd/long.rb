# frozen_string_literal: true

module Metadata
  module Shared
    module Xsd
      class Long < Lutaml::Model::Type::Decimal
        class << self
          def cast(value)
            return nil if value.nil?

            super
          end
        end
      end
    end
  end
end
