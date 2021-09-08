# frozen_string_literal: true

module Mutations
  module Contracts
    class CommunityInput < ApplicationContract
      json do
        required(:title).filled("coercible.string")
      end
    end
  end
end
