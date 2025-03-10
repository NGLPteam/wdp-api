# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class KwdDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent
      end
    end
  end
end
