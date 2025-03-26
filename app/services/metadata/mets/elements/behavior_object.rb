# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # Corresponds to an `<interfaceDef />` or `<mechanism />` on a `<behavior/>`.
      #
      # @note Not really implemented yet since we haven't needed it.
      class BehaviorObject < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::Location
        include Metadata::METS::AttributeGroups::SimpleLink

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :label, :string

        xml do
          no_root

          map_attribute "ID", to: :id
          map_attribute "LABEL", to: :label
        end
      end
    end
  end
end
