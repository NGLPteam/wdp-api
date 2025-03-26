# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EnvironmentFunction < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :level, :string

        xml do
          root "environmentFunction", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :environmentFunctionType, to: :type
          map_element :environmentFunctionLevel, to: :level
        end
      end
    end
  end
end
