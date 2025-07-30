# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Check
      class Data < Metadata::Pressbooks::Common::AbstractMapper
        attribute :namespace, :string

        attribute :routes, ::Metadata::Pressbooks::Common::Route, collection: true

        json do
          map "namespace", to: :namespace

          map "routes", to: :routes, child_mappings: {
            path: :key,
            namespace: %w[namespace],
            http_methods: %w[methods],
          }
        end
      end
    end
  end
end
