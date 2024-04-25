# frozen_string_literal: true

# frozen_string_literal

module ScopesForMetadataFormat
  extend ActiveSupport::Concern

  included do
    scope :for_metadata_format, ->(metadata_format) { where(metadata_format:) }
    scope :with_jats_format, -> { for_metadata_format "jats" }
    scope :with_mets_format, -> { for_metadata_format "mets" }
    scope :with_mods_format, -> { for_metadata_format "mods" }
  end
end
