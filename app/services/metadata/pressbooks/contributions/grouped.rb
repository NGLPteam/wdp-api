# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Contributions
      # Groups Person / Organization records into role-based listings for easier harvesting.
      class Grouped < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :role, :string, default: -> { "ctb" }
        attribute :contributors, ::Metadata::Pressbooks::SchemaDotOrg::Abstract, collection: true, polymorphic: [
          ::Metadata::Pressbooks::SchemaDotOrg::Organization,
          ::Metadata::Pressbooks::SchemaDotOrg::Person,
        ]
      end
    end
  end
end
