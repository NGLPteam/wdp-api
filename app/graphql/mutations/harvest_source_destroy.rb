# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestSourceDestroy
  class HarvestSourceDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `HarvestSource` record.
    TEXT

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The harvest source to destroy.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_source_destroy", destroy: true
  end
end
