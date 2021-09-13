# frozen_string_literal: true

module Mutations
  module Contracts
    class UpdateEntityThumbnail < ApplicationContract
      json do
        optional(:clear_thumbnail).maybe(:bool)
        optional(:thumbnail).maybe(:hash)
      end

      rule(:clear_thumbnail, :thumbnail) do
        key(:thumbnail).failure(:update_and_clear_attachment) if values[:clear_thumbnail].present? && values[:thumbnail].present?
      end
    end
  end
end
