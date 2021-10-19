# frozen_string_literal: true

module Mutations
  module Operations
    class UpdatePage
      include MutationOperations::Base

      use_contract! :page_input
      use_contract! :update_page

      def call(page:, position: nil, hero_image: nil, clear_hero_image: false, **args)
        authorize page.entity, :update?

        page.assign_attributes args

        page.position = position if position.present?

        persist_model! page, attach_to: :page
      end
    end
  end
end
