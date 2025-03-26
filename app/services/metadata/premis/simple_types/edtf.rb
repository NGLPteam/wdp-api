# frozen_string_literal: true

module Metadata
  module PREMIS
    module SimpleTypes
      class Edtf < Lutaml::Model::Type::String
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
