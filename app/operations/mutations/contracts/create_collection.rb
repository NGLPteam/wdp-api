# frozen_string_literal: true

module Mutations
  module Contracts
    class CreateCollection < ApplicationContract
      json do
        required(:schema_version_slug).filled(:string)
      end
    end
  end
end
