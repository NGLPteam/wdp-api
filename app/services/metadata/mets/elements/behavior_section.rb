# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class BehaviorSection < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :created, :date_time
        attribute :label, :string
        attribute :behavior_sections, self, collection: true
        attribute :behaviors, ::Metadata::METS::Elements::Behavior, collection: true, expose_single: true

        xml do
          root "behaviorSec", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "CREATED", to: :created
          map_attribute "LABEL", to: :label

          map_element :behaviorSec, to: :behavior_sections
          map_element :behavior, to: :behaviors
        end
      end
    end
  end
end
