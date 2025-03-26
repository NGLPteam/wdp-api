# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      #	BETYPE (string/O): An attribute that specifies the kind of BEGIN and/or END
      #	values that are being used. For example, if BYTE is specified, then the
      #	BEGIN and END point values represent the byte offsets into a file. If
      #	IDREF is specified, then the BEGIN element specifies the ID value that
      #	identifies the element in a structured text file where the relevant
      #	section of the file begins; and the END value (if present) would specify
      #	the ID value that identifies the element with which the relevant section
      #	of the file ends.
      class BeginEndType < ::Metadata::Shared::AbstractEnum
        values! %w[
          BYTE
          IDREF
          SMIL
          MIDI
          SMPTE-25
          SMPTE-24
          SMPTE-DF30
          SMPTE-NDF30
          SMPTE-DF29.97
          SMPTE-NDF29.97
          TIME
          TCF
          XPTR
        ]
      end
    end
  end
end
