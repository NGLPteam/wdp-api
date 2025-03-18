# frozen_string_literal: true

module Types
  class HarvestScheduleModeType < Types::BaseEnum
    description <<~TEXT
    Harvest schedule mode enum
    TEXT

    value "MANUAL", value: "manual" do
      description <<~TEXT
      TEXT
    end

    value "SCHEDULED", value: "scheduled" do
      description <<~TEXT
      TEXT
    end
  end
end
