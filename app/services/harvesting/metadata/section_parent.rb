# frozen_string_literal: true

module Harvesting
  module Metadata
    # An interface for objects that can contain multiple {Harvesting::Metadata::Section sections}
    # by way of a {Harvesting::Metadata::SectionMap}.
    module SectionParent
      # @see Harvesting::Metadata::SectionMap.build_for
      # @param [#to_s] name
      # @param [{ Symbol => Object }] options
      # @yieldparam [Harvesting::Metadata::SectionMap::Builder] builder
      # @yieldreturn [Harvesting::Metadata::Section]
      def build_section_map(name, **options)
        Harvesting::Metadata::SectionMap.build_for(self, name, **options) do |builder|
          yield builder
        end
      end
    end
  end
end
