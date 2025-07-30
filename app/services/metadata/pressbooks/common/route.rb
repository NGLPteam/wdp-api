# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Common
      class Route < AbstractMapper
        attribute :path, :string
        attribute :namespace, :string
        attribute :http_methods, :string, collection: true, initialize_empty: true
      end
    end
  end
end
