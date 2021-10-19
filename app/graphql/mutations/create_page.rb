# frozen_string_literal: true

module Mutations
  class CreatePage < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Create a page on an entity.
    TEXT

    field :page, Types::PageType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true

    argument :title, String, required: true, attribute: true
    argument :slug, String, required: true, attribute: true
    argument :position, Integer, required: false, attribute: true
    argument :body, String, required: true, attribute: true

    argument :hero_image, Types::UploadedFileInputType, required: false, attribute: true do
      description <<~TEXT.strip_heredoc
      The hero image to represent the page.
      TEXT
    end

    performs_operation! "mutations.operations.create_page"
  end
end
