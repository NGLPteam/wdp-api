# frozen_string_literal: true

module HasHarvestModificationStatus
  extend ActiveSupport::Concern

  included do
    pg_enum! :harvest_modification_status, as: :harvest_modification_status, allow_blank: false, default: "unharvested", suffix: :for_harvest
  end

  # A hook called when the record is found by a harvesting action.
  #
  # Specifically, it will transform existing `unharvested` records to `modified`
  # in order to preserve and migrate existing records without clobbering
  # their data by the harvesting action.
  #
  # @return [void]
  def found_by_harvesting_action!
    return unless unharvested_for_harvest?

    if persisted?
      update_column :harvest_modification_status, "modified"

      return
    else
      self.harvest_modification_status = "pristine"
    end
  end
end
