# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @abstract
      class Abstract < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :schema_org_context, :string
        attribute :schema_org_type, :string, polymorphic_class: true

        require_relative "./book"

        json do
          map "@context", to: :schema_org_context

          map "@type", to: :schema_org_type,
            polymorphic_map: {
              "Book" => "::Metadata::Pressbooks::SchemaDotOrg::Book",
              "Chapter" => "::Metadata::Pressbooks::SchemaDotOrg::Chapter",
              "CreativeWork" => "::Metadata::Pressbooks::SchemaDotOrg::CreativeWork",
              "Language" => "::Metadata::Pressbooks::SchemaDotOrg::Language",
              "Organization" => "::Metadata::Pressbooks::SchemaDotOrg::Organization",
              "Person" => "::Metadata::Pressbooks::SchemaDotOrg::Person",
              "Thing" => "::Metadata::Pressbooks::SchemaDotOrg::Thing",
            }
        end
      end
    end
  end
end
