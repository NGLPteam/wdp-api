# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      # LOCTYPE (string/R): Specifies the locator type used in the xlink:href attribute. Valid values for LOCTYPE are:
      class LocType < ::Metadata::Shared::AbstractEnum
        values! "ARK", "URN", "URL", "PURL", "HANDLE", "DOI", "OTHER"
      end
    end
  end
end
