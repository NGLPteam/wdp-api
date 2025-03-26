# frozen_string_literal: true

module Metadata
  module PREMIS
    module ComplexTypes
      class StartAndEndDate < Lutaml::Model::Serializable
        attribute :start_date, ::Metadata::PREMIS::SimpleTypes::Edtf
        attribute :end_date, ::Metadata::PREMIS::SimpleTypes::Edtf

        xml do
          no_root

          map_element :startDate, to: :start_date
          map_element :endDate, to: :end_date
        end
      end
    end
  end
end
