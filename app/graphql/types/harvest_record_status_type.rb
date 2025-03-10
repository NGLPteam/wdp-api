# frozen_string_literal: true

module Types
  class HarvestRecordStatusType < Types::BaseEnum
    description <<~TEXT
    A harvested record can exist in a number of statuses.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      A brand new record that hasn't been processed yet.
      TEXT
    end

    value "ACTIVE", value: "active" do
      description <<~TEXT
      An record that is considered active and ready to be extracted into entities.
      TEXT
    end

    value "SKIPPED", value: "skipped" do
      description <<~TEXT
      A record that was skipped over for some validation reason.
      TEXT
    end

    value "DELETED", value: "deleted" do
      description <<~TEXT
      A record that was deleted in the upstream harvest source.
      TEXT
    end
  end
end
