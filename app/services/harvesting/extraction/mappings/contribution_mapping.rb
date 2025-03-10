# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      class ContributionMapping < Abstract
        attribute :vocabulary_identifier, :string
        attribute :default_identifier, :string
        attribute :external_role_mappings, ExternalContributionRoleMapping, collection: true, default: -> { [] }

        xml do
          root "contributions"

          map_attribute "vocabulary", to: :vocabulary_identifier
          map_attribute "default", to: :default_identifier
          map_element "map-external-role", to: :external_role_mappings
        end

        # @return [Harvesting::Extraction::Contributions::Config]
        def to_config
          external_role_mappers = external_role_mappings.compact_blank.map(&:to_mapper)

          Harvesting::Extraction::Contributions::Config.new(
            vocabulary_identifier:,
            default_identifier:,
            external_role_mappers:
          )
        end
      end
    end
  end
end
