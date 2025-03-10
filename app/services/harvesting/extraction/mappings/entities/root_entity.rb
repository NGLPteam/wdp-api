# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        module RootEntity
          extend ActiveSupport::Concern

          included do
            root true

            attribute :metadata_mapping, Harvesting::Extraction::Mappings::Entities::MetadataMapping
          end
        end
      end
    end
  end
end
