# frozen_string_literal: true

module Mutations
  module Contracts
    class EntityInput < ApplicationContract
      json do
        required(:title).filled("coercible.string")
        optional(:doi).maybe("coercible.string")
        optional(:subtitle).maybe("coercible.string")
        optional(:summary).maybe("coercible.string")
      end
    end
  end
end
