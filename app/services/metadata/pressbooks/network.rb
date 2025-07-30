# frozen_string_literal: true

module Metadata
  module Pressbooks
    class Network < ::Metadata::Pressbooks::Common::AbstractMapper
      attribute :host, :string
      attribute :name, :string

      json do
        map "host", to: :host
        map "name", to: :name
      end
    end
  end
end
