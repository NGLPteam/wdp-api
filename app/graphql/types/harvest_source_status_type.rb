# frozen_string_literal: true

module Types
  class HarvestSourceStatusType < Types::BaseEnum
    description <<~TEXT
    An enum that describes the functional state for harvest sources.

    Harvest sources are checked on a regular basis and can also be
    manually rechecked with harvestSourceCheck
    TEXT

    value "ACTIVE", value: "active" do
      description <<~TEXT
      An active harvest source has been recently validated as working
      and thus can be used for harvesting.
      TEXT
    end

    value "INACTIVE", value: "inactive" do
      description <<~TEXT
      An inactive harvest source has been recently validated as not working
      and cannot be used for harvesting.
      TEXT
    end
  end
end
