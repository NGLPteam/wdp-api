# frozen_string_literal: true

# An interface for harvesting-related records that store a {HarvestMetadataFormat}.
module HasHarvestMetadataFormat
  extend ActiveSupport::Concern

  included do
    pg_enum! :metadata_format, as: :harvest_metadata_format, allow_blank: false, prefix: :with, suffix: :format

    composed_of :harvest_metadata_format,
      class_name: "HarvestMetadataFormat",
      mapping: [%w[metadata_format name]],
      constructor: ->(name) { HarvestMetadataFormat.find(name) }

    scope :for_metadata_format, ->(metadata_format) { where(metadata_format:) }
  end
end
