# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @note Not part of schema.org but has thing-derived shape.
      class Institution < Thing
        attribute :legal_name, :string

        json do
          map "legalName", to: :legal_name
        end
      end
    end
  end
end
