# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @see https://schema.org/CreativeWork
      class CreativeWork < Thing
        include Metadata::Pressbooks::Contributions::HasGrouped

        attribute :about, Thing, collection: true
        attribute :abstract, :string
        attribute :authors, Abstract, collection: true, polymorphic: [Organization, Person]
        attribute :comment_count, :integer

        attribute :copyright_holder, Abstract, polymorphic: [Organization, Person]
        attribute :copyright_notice, :string
        attribute :copyright_year, :integer

        attribute :creators, Abstract, collection: true, polymorphic: [Organization, Person]

        attribute :date_created, :date
        attribute :date_published, :date
        attribute :date_updated, :date

        attribute :editors, Person, collection: true

        attribute :in_language, :string

        attribute :institutions, Institution, collection: true

        attribute :is_part_of, :string

        attribute :keywords, :string, collection: true

        attribute :license, self

        attribute :publisher, Abstract, polymorphic: [Organization, Person]

        attribute :reviewers, Abstract, collection: true, polymorphic: [Organization, Person]

        attribute :text, :string
        attribute :thumbnail_url, :string
        attribute :translators, Abstract, collection: true, polymorphic: [Organization, Person]

        groups_contributions! :authors, role: "aut"
        groups_contributions! :creators, role: "cre"
        groups_contributions! :editors, role: "edt"
        groups_contributions! :reviewers, role: "rev"
        groups_contributions! :translators, role: "trl"

        json do
          map "about", to: :about
          map "abstract", to: :abstract
          map "author", to: :authors
          map "commentComment", to: :comment_count
          map "copyrightHolder", to: :copyright_holder
          map "copyrightNotice", to: :copyright_notice
          map "copyrightYear", to: :copyright_year
          map "creator", to: :creators

          map "dateCreated", to: :date_created
          map "datePublished", to: :date_published
          map "dateUpdated", to: :date_updated

          map "editor", to: :editors

          map "inLanguage", to: :in_language

          map "institutions", to: :institutions

          map "isPartOf", to: :is_part_of

          map "keywords", to: :keywords

          map "license", to: :license

          map "publisher", to: :publisher

          map "reviewedBy", to: :reviewers

          map "text", to: :text
          map "thumbnailUrl", to: :thumbnail_url
          map "translator", to: :translators
        end
      end
    end
  end
end
