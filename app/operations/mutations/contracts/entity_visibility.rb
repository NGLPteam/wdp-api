# frozen_string_literal: true

module Mutations
  module Contracts
    class EntityVisibility < ApplicationContract
      json do
        required(:visibility).filled(::Entities::Types::Visibility)
        optional(:visible_after_at).maybe(:time)
        optional(:visible_until_at).maybe(:time)
      end

      rule(:visibility, :visible_after_at, :visible_until_at) do
        if values[:visibility] == "limited"
          if values[:visible_after_at].blank? && values[:visible_until_at].blank?
            key(:visibility).failure(:limited_visibility_requires_range)
            key(:visible_after_at).failure(:range_required_when_limited_visibility)
            key(:visible_until_at).failure(:range_required_when_limited_visibility)
          elsif values[:visible_after_at].present? && values[:visible_until_at].present?
            key(:visible_until_at).failure(:limited_visibility_inverted_range) if values[:visible_until_at] <= values[:visible_after_at]
          end
        end
      end
    end
  end
end
