# frozen_string_literal: true

module Metadata
  module METS
    module AttributeGroups
      module FileCore
        extend ActiveSupport::Concern

        included do
          attribute :mimetype, :string
          attribute :size, :integer
          attribute :created, :date_time
          attribute :checksum, :string
          attribute :checksumtype, ::Metadata::METS::Enums::ChecksumType

          xml do
            map_attribute "MIMETYPE", to: :mimetype
            map_attribute "SIZE", to: :size
            map_attribute "CREATED", to: :created
            map_attribute "CHECKSUM", to: :checksum
            map_attribute "CHECKSUMTYPE", to: :checksumtype
          end
        end
      end
    end
  end
end
