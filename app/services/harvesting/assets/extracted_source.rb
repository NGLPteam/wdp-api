# frozen_string_literal: true

module Harvesting
  module Assets
    class ExtractedSource
      include StoreModel::Model

      attribute :identifier, :string
      attribute :url, :string

      attribute :name, :string
      attribute :mime_type, :string

      validates :identifier, :url, presence: true

      def to_metadata
        {
          mime_type: mime_type.presence,
          name: name.presence,
        }.compact
      end
    end
  end
end
