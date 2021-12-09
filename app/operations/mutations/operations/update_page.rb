# frozen_string_literal: true

module Mutations
  module Operations
    class UpdatePage
      include MutationOperations::Base

      use_contract! :page_input

      use_contract! :update_page

      attachment! :hero_image, image: true

      def call(page:, position: nil, **args)
        authorize page.entity, :update?

        assign_attributes! page, **args

        page.position = position if position.present?

        persist_model! page, attach_to: :page
      end
    end
  end
end
