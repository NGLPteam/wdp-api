# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class ExtentType < ::Metadata::Shared::AbstractEnum
        values! "BYTE", "SMIL", "MIDI",
          "SMPTE-25", "SMPTE-24", "SMPTE-DF30", "SMPTE-NDF30", "SMPTE-DF29.97", "SMPTE-NDF29.97",
          "TIME", "TCF"
      end
    end
  end
end
