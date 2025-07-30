# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @note This type has several extensions on schema.org/Person that
      #   seem to come with pressbooks.
      class Person < Thing
        include Metadata::Pressbooks::Naming::HasPersonalName

        attribute :contributor_first_name, :string
        attribute :contributor_last_name, :string
        attribute :slug, :string

        attribute :given_name, method: :derived_given_name
        attribute :family_name, method: :derived_family_name

        json do
          map "contributor_first_name", to: :contributor_first_name
          map "contributor_last_name", to: :contributor_last_name
          map "slug", to: :slug
        end

        # @api private
        # @return [String, nil]
        def derived_given_name
          contributor_first_name.presence || parsed_name.given.presence
        end

        # @api private
        # @return [String, nil]
        def derived_family_name
          contributor_last_name.presence || parsed_name.family.presence
        end

        # @api private
        def parsed_name_source
          name
        end
      end
    end
  end
end
