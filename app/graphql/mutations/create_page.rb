# frozen_string_literal: true

module Mutations
  class CreatePage < Mutations::BaseMutation
    description <<~TEXT
    Create a page on an entity.
    TEXT

    field :page, Types::PageType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true

    argument :title, String, required: true, attribute: true
    argument :slug, String, required: true, attribute: true
    argument :position, Integer, required: false, attribute: true
    argument :body, String, required: true, attribute: true

    image_attachment! :hero_image

    performs_operation! "mutations.operations.create_page"
  end
end
