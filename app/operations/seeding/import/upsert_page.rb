# frozen_string_literal: true

module Seeding
  module Import
    # Upsert a {Page} for a {HierarchicalEntity}.
    class UpsertPage
      include MonadicPersistence
      include Dry::Monads[:result, :do]
      include MeruAPI::Deps[
        attach_image_property: "seeding.import.attach_image_property",
      ]

      # @param [HierarchicalEntity] entity
      # @param [Seeding::Import::Structs::Page] page_source
      # @return [Dry::Monads::Success(Page)]
      # @return [Dry::Monads::Failure]
      def call(entity, page_source)
        return Success(nil) if page_source.blank?

        page = entity.pages.by_slug(page_source.slug).first_or_initialize

        page.assign_attributes page_source.assignable_attributes

        page_source.images.each do |key, asset|
          yield attach_image_property.(page, key, asset)
        end

        monadic_save page
      end
    end
  end
end
