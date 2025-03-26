# frozen_string_literal: true

module Metadata
  module METS
    module AttributeGroups
      module SimpleLink
        extend ActiveSupport::Concern

        XLINK = "http://www.w3.org/1999/xlink"

        included do
          attribute :link_type, :string, default: "simple"
          attribute :href, :string

          xml do
            map_attribute :href, namespace: ::Metadata::METS::AttributeGroups::SimpleLink::XLINK, prefix: :xlink, to: :href
            map_attribute :type, namespace: ::Metadata::METS::AttributeGroups::SimpleLink::XLINK, prefix: :xlink, to: :link_type
          end
        end
      end
    end
  end
end
