# frozen_string_literal: true

module Entities
  class AddFakeThumbnail
    include Dry::Monads[:do, :result]
    include MonadicPersistence

    ORIGINAL_SIZE = "1000x1000"

    def call(entity)
      return Success(entity) if entity.thumbnail.present?

      entity.thumbnail_remote_url = Faker::LoremPixel.image size: ORIGINAL_SIZE

      monadic_save entity
    end
  end
end
