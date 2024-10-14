# frozen_string_literal: true

FactoryBot.define do
  factory :layout_invalidation do
    stale_at { Time.current }

    trait :existing_entity do
      entity { FactoryBot.create(:community) }
    end

    trait :missing_entity do
      entity_id { SecureRandom.uuid }
      entity_type { "Community" }
    end
  end
end
