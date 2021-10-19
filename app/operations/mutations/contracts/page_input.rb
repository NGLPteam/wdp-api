# frozen_string_literal: true

module Mutations
  module Contracts
    class PageInput < ApplicationContract
      json do
        required(:title).filled("coercible.string")
        required(:body).filled("coercible.string")
        required(:slug).filled("coercible.string")
      end

      rule(:slug).validate(:slug_format)
    end
  end
end
