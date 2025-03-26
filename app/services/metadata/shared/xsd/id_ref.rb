# frozen_string_literal: true

module Metadata
  module Shared
    module Xsd
      class IdRef < Lutaml::Model::Type::String
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
