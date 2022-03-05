# frozen_string_literal: true

module Harvesting
  module Metadata
    # @see Harvesting::Types::MetadataSection
    module Section
      extend ActiveSupport::Concern
      extend Shared::Typing

      included do
        extend Dry::Core::ClassAttributes

        defines :section_tags, type: Harvesting::Types::SectionTags

        section_tags [].freeze

        delegate :section_tags, to: :class
      end

      # @!attribute [rw] section_map
      # @return [Harvesting::Metadata::SectionMap]
      attr_accessor :section_map

      delegate :name, :parent, to: :section_map, prefix: :section, allow_nil: true

      # @abstract
      # A unique string used to identify the section.
      # @return [String]
      def section_id
        # :nocov:
        object_id.to_s(16)
        # :nocov:
      end

      # Check if this section has a specific tag.
      #
      # @param [Symbol] tag
      def tagged_with?(tag)
        tag.in? section_tags
      end

      class_methods do
        # Add new tags for this section class.
        # @param [<#to_sym>] raw_tags
        # @return [void]
        def tag_section!(*raw_tags)
          new_tags = Harvesting::Types::SectionTags[raw_tags.flatten]

          merged_tags = section_tags | new_tags

          section_tags merged_tags.freeze
        end
      end
    end
  end
end
