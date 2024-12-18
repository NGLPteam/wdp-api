# frozen_string_literal: true

FactoryBot.define do
  factory :ordering_invalidation do
    ordering { nil }
    stale_at { "2024-12-18 11:38:03" }
  end
end
