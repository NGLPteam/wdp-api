# frozen_string_literal: true

module Metadata
  module METS
    module AttributeGroups
      module Location
        extend ActiveSupport::Concern

        included do
          attribute :loctype, ::Metadata::METS::Enums::LocType
          attribute :otherloctype, :string

          xml do
            map_attribute "LOCTYPE", to: :loctype
            map_attribute "OTHERLOCTYPE", to: :otherloctype
          end
        end
      end
    end
  end
end
