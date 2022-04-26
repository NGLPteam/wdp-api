# frozen_string_literal: true

module Seeding
  module Import
    # Upsert an array of pages for a {HierarchicalEntity}.
    class UpsertPages
      include MonadicPersistence
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        upsert_page: "seeding.import.upsert_page",
      ]

      # @param [HierarchicalEntity] entity
      # @param [#pages] source
      # @return [Dry::Monads::Success(Page)]
      # @return [Dry::Monads::Failure]
      def call(entity, source)
        source.pages.each do |page_source|
          yield upsert_page.(entity, page_source)
        end

        Success()
      end
    end
  end
end
