# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      class Thing < ::Metadata::Pressbooks::SchemaDotOrg::Abstract
        attribute :alternate_name, :string

        attribute :code, :string

        attribute :description, :string

        attribute :disambiguating_description, :string

        attribute :identifier, :string

        attribute :image_url, :string

        attribute :name, :string

        attribute :slug, :string

        attribute :url, :string

        json do
          map "alternateName", to: :alternate_name

          map "code", to: :code

          map "description", to: :description

          map "disambiguatingDescription", to: :disambiguating_description

          map "identifier", to: :identifier

          map "image", to: :image_url, with: { from: :image_from_json, to: :image_to_json }

          map "name", to: :name

          map "slug", to: :slug

          map "url", to: :url
        end

        def image_from_json(model, value)
          case value
          when String
            model.image_url = value
          end
        end

        def image_to_json(model, doc)
          doc["image"] = model.image_url
        end
      end
    end
  end
end
