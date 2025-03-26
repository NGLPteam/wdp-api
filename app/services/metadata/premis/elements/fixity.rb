# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Fixity < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :message_digest, :string
        attribute :message_digest_algorithm, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :message_digest_originator, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "fixity", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :messageDigest, to: :message_digest
          map_element :messageDigestAlgorithm, to: :message_digest_algorithm
          map_element :messageDigestOriginator, to: :message_digest_originator
        end
      end
    end
  end
end
