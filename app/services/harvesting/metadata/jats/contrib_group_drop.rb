# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ContribGroupDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        data_subdrops! Harvesting::Metadata::JATS::ContribDrop, :contrib
      end
    end
  end
end
