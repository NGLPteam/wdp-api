# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class Header < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs

        attribute :create_date, :date_time
        attribute :last_mod_date, :date_time
        attribute :record_status, :string
        attribute :agents, ::Metadata::METS::Elements::Agent, collection: true
        attribute :alt_record_ids, ::Metadata::METS::Elements::AltRecordId, collection: true
        attribute :mets_document_id, ::Metadata::METS::Elements::METSDocumentId

        xml do
          root "metsHdr", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "ADMID", to: :admid
          map_attribute "CREATEDATE", to: :create_date
          map_attribute "LASTMODDATE", to: :last_mod_date
          map_attribute "RECORDSTATUS", to: :record_status

          map_element "agent", to: :agents
          map_element "altRecordID", to: :alt_record_ids
          map_element "metsDocumentID", to: :mets_document_id
        end
      end
    end
  end
end
