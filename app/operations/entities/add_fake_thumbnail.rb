# frozen_string_literal: true

module Entities
  class AddFakeThumbnail
    include Dry::Monads[:do, :result]
    include MonadicPersistence

    DEFAULT_IMAGE = Rails.root.join("public", "images", "large.png")

    def call(entity)
      return Success(entity) if entity.thumbnail.present?

      DEFAULT_IMAGE.open "r+" do |f|
        f.binmode

        entity.thumbnail = f

        monadic_save entity
      end
    end
  end
end
