# frozen_string_literal: true

module Metadata
  module METS
    module AttributeGroups
      module OrderLabels
        extend ActiveSupport::Concern

        included do
          attribute :order, :integer
          attribute :orderlabel, :string
          attribute :label, :string

          xml do
            map_attribute "ORDER", to: :order
            map_attribute "ORDERLABEL", to: :orderlabel
            map_attribute "LABEL", to: :label
          end
        end
      end
    end
  end
end
