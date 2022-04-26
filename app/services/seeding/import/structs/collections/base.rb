# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        # @abstract
        class Base < Seeding::Import::Structs::Base
          attribute :identifier, Seeding::Types::String
          attribute :title, Seeding::Types::String

          attribute? :subtitle, Seeding::Types::String.optional
          attribute? :doi, Seeding::Types::String.optional
          attribute? :issn, Seeding::Types::String.optional

          attribute? :collections, Seeding::Import::Structs::Collections::AnyList
          attribute? :pages, Seeding::Import::Structs::Page.as_list

          attribute? :hero_image, Seeding::Import::Structs::Assets::Any.optional
          attribute? :thumbnail, Seeding::Import::Structs::Assets::Any.optional

          def core_properties
            slice(:subtitle, :doi, :issn)
          end

          def images
            slice(:hero_image, :thumbnail)
          end
        end
      end
    end
  end
end
