# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class MetadataType < ::Metadata::Shared::AbstractEnum
        values!(
          "MARC",
          "MODS",
          "EAD",
          "DC",
          "NISOIMG",
          "LC-AV",
          "VRA",
          "TEIHDR",
          "DDI",
          "FGDC",
          "LOM",
          "PREMIS",
          "PREMIS:OBJECT",
          "PREMIS:AGENT",
          "PREMIS:RIGHTS",
          "PREMIS:EVENT",
          "TEXTMD",
          "METSRIGHTS",
          "ISO 19115:2003 NAP",
          "EAC-CPF",
          "LIDO",
          "OTHER"
        )
      end
    end
  end
end
