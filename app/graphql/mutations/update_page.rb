# frozen_string_literal: true

module Mutations
  class UpdatePage < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Update a page.
    TEXT

    field :page, Types::PageType, null: true

    argument :page_id, ID, loads: Types::PageType, required: true

    argument :title, String, required: true, attribute: true
    argument :slug, String, required: true, attribute: true
    argument :position, Integer, required: false, attribute: true
    argument :body, String, required: true, attribute: true

    image_attachment! :hero_image

    clearable_attachment! :hero_image

    performs_operation! "mutations.operations.update_page"
  end
end
