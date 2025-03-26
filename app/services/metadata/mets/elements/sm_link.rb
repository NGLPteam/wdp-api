# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class SmLink < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :arcrole, :string
        attribute :title, :string
        attribute :show, :string
        attribute :actuate, :string
        attribute :to, :string
        attribute :from, :string

        xml do
          root "smLink", mixed: true
          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "ARCROLE", to: :arcrole
          map_attribute "TITLE", to: :title
          map_attribute "SHOW", to: :show
          map_attribute "ACTUATE", to: :actuate
          map_attribute "TO", to: :to
          map_attribute "FROM", to: :from
        end
      end
    end
  end
end
