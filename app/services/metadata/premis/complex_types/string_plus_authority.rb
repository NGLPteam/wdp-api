# frozen_string_literal: true

module Metadata
  module PREMIS
    module ComplexTypes
      class StringPlusAuthority < Lutaml::Model::Serializable
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :content, :string
        attribute :value_uri, :string

        xml do
          no_root

          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri

          map_content to: :content
        end
      end
    end
  end
end
