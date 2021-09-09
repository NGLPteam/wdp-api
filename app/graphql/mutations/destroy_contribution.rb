# frozen_string_literal: true

module Mutations
  class DestroyContribution < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy a Contribution by ID.
    TEXT

    argument :contribution_id, ID, loads: Types::ContributionType, required: true

    performs_operation! "mutations.operations.destroy_contribution", destroy: true
  end
end
