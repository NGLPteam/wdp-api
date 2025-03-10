# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      module HasContribGroup
        extend ActiveSupport::Concern

        included do
          data_subdrops! ContribGroupDrop, :contrib_group
        end
      end
    end
  end
end
