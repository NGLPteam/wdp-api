# frozen_string_literal: true

module Mutations
  module Contracts
    class UpsertContribution < ApplicationContract
      json do
        required(:contributable).value(:contributable)
        required(:contributor).value(:contributor)
        optional(:role).maybe(:controlled_vocabulary_item)
        optional(:inner_position).maybe(:integer)
        optional(:outer_position).maybe(:integer)
      end
    end
  end
end
