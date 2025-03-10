# frozen_string_literal: true

module Harvesting
  module Entities
    class ExtractedAttributes
      include Support::EnhancedStoreModel

      attribute :title, :string

      attribute :subtitle, :string

      attribute :summary, :string

      attribute :doi, :string

      attribute :published, :variable_precision_date

      def to_assign
        {
          title:,
          subtitle:,
          summary:,
          doi:,
          published:,
        }
      end
    end
  end
end
