# frozen_string_literal: true

module Mutations
  class DestroyPage < Mutations::BaseMutation
    description <<~TEXT
    Destroy a page by ID.
    TEXT

    argument :page_id, ID, loads: Types::PageType, required: true

    performs_operation! "mutations.operations.destroy_page", destroy: true
  end
end
