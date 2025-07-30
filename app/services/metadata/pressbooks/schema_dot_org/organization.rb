# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      class Organization < Thing
        attribute :legal_name, :string

        json do
          map "legalName", to: :legal_name
        end
      end
    end
  end
end
