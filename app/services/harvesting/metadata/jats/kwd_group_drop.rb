# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class KwdGroupDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        data_subdrops! Harvesting::Metadata::JATS::KwdDrop, :kwd
      end
    end
  end
end
