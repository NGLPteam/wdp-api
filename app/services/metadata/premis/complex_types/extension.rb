# frozen_string_literal: true

module Metadata
  module PREMIS
    module ComplexTypes
      class Extension < Lutaml::Model::Serializable
        attribute :content, :string

        xml do
          no_root

          map_all to: :content
        end
      end
    end
  end
end
