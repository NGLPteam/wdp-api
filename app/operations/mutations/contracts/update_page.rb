# frozen_string_literal: true

module Mutations
  module Contracts
    class UpdatePage < ApplicationContract
      json do
        required(:page).value(AppTypes.Instance(::Page))
        required(:slug).filled("coercible.string")
        optional(:clear_hero_image).maybe(:bool)
        optional(:hero_image).maybe(:hash)
      end

      rule(:page, :slug) do
        page = values[:page]
        slug = values[:slug]
        entity = page.entity

        slug_is_not_unique = entity.pages.where.not(id: page.id).by_slug(slug).exists?

        key(:slug).failure(:must_be_unique_slug) if slug_is_not_unique
      end

      rule(:clear_hero_image, :hero_image) do
        key(:clear_hero_image).failure("cannot be set while uploading a new Hero Image") if values[:clear_hero_image].present? && values[:hero_image].present?
      end
    end
  end
end
