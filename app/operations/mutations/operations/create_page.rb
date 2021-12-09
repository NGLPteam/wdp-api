# frozen_string_literal: true

module Mutations
  module Operations
    class CreatePage
      include MutationOperations::Base

      use_contract! :page_input
      use_contract! :create_page

      attachment! :hero_image, image: true

      def call(entity:, position: nil, **args)
        authorize entity, :update?

        page = entity.pages.new

        assign_attributes! page, **args

        page.position = position if position.present?

        persist_model! page, attach_to: :page
      end
    end
  end
end
