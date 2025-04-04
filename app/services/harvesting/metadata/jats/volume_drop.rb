# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class VolumeDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent

        data_attr! :seq, :integer
      end
    end
  end
end
