# frozen_string_literal: true

module Types
  class HarvestTargetKindType < Types::BaseEnum
    description <<~TEXT
    The kind of entity that's being used as a Harvest Target.
    TEXT

    value "COMMUNITY", value: "community" do
      description <<~TEXT
      A root-level entity in the hierarchy.
      TEXT
    end

    value "COLLECTION", value: "collection" do
      description <<~TEXT
      A branch or leaf in the hierarchy.
      TEXT
    end
  end
end
