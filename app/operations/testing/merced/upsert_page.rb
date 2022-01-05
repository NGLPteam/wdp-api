# frozen_string_literal: true

module Testing
  module Merced
    # Upsert {Page} records for a {Collection}.
    # @operation
    class UpsertPage
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      prepend HushActiveRecord

      # @param [ActiveSupport::HashWithIndifferentAccess] page_definition
      # @param [Integer] index
      # @return [Dry::Monads::Result]
      def call(page_definition, index: 0, parent: nil)
        page = parent.pages.by_slug(page_definition[:slug]).first_or_initialize

        page.title = page_definition[:title]

        page.position = index + 1

        page.body = page_definition[:html]

        monadic_save page
      end
    end
  end
end
