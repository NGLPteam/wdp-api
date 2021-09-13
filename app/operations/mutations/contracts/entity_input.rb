# frozen_string_literal: true

module Mutations
  module Contracts
    class EntityInput < ApplicationContract
      json do
        required(:title).filled("coercible.string")
      end
    end
  end
end
