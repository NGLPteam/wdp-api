# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ArticleIdDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent

        data_attr! :pub_id_type, :string
      end
    end
  end
end
