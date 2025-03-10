# frozen_string_literal: true

# An interface for entities that attach harvested assets.
module HasHarvestAssets
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  # @see Harvesting::Entities::AttachAssets
  monadic_operation! def attach_harvested_assets(...)
    call_operation("harvesting.entities.attach_assets", self, ...)
  end
end
