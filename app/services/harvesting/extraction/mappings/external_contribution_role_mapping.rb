# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      class ExternalContributionRoleMapping < Abstract
        attribute :from, :string
        attribute :to, :string
        attribute :case_insensitive, :boolean, default: -> { false }

        xml do
          root "map-external-role"

          map_attribute "from", to: :from
          map_attribute "to", to: :to
          map_attribute "case-insensitive", to: :case_insensitive
        end

        def empty?
          from.blank? || to.blank?
        end

        # @return [Harvesting::Extraction::Contributions::ExternalRoleMapper]
        def to_mapper
          Harvesting::Extraction::Contributions::ExternalRoleMapper.new(from:, to:, case_insensitive:)
        end
      end
    end
  end
end
