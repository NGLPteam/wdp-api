# frozen_string_literal: true

module Mutations
  module Contracts
    class DestroyCommunity < ApplicationContract
      json do
        required(:community).filled(Support::GlobalTypes.Instance(Community))
      end

      rule(:community) do
        key(:$global).failure(:destroy_community_with_collections) if value.collections.exists?
      end
    end
  end
end
