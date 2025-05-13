# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class HistoryDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        data_subdrops! DateDrop, :date
      end
    end
  end
end
