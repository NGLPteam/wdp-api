# frozen_string_literal: true

module Seeding
  module Contracts
    # Seed a {::Page}.
    class PageImport < Base
      json do
        required(:slug).filled(:string)
        required(:title).filled(:string)
        required(:body).value(:string)
        optional(:hero_image).maybe(:asset)
      end

      rule(:slug).validate(:slug_format)
    end
  end
end
