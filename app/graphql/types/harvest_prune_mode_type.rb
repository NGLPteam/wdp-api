# frozen_string_literal: true

module Types
  class HarvestPruneModeType < Types::BaseEnum
    description <<~TEXT
    The selection criteria for pruning entities from a harvest.
    TEXT

    value "UNMODIFIED", value: "unmodified" do
      description <<~TEXT
      Prune **only** unmodified harvested entities.

      Note that unmodified entities _may_ be left behind
      if one of their child entities has been modified.
      TEXT
    end

    value "EVERYTHING", value: "everything" do
      description <<~TEXT
      Prune **all** entities that have been harvested by the source or attempt.
      TEXT
    end
  end
end
