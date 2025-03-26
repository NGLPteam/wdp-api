# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class ChecksumType < ::Metadata::Shared::AbstractEnum
        values! "Adler-32", "CRC32", "HAVAL", "MD5", "MNP", "SHA-1", "SHA-256", "SHA-384", "SHA-512", "TIGER", "WHIRLPOOL"
      end
    end
  end
end
