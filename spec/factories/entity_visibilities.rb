# frozen_string_literal: true

FactoryBot.define do
  factory :entity_visibility do
    association :entity, factory: :item

    visibility { :visible }

    trait :visible do
      visibility { :visible }
    end

    trait :hidden do
      visibility { :hidden }
    end

    trait :limited do
      visibility { :limited }

      visible_after_at { 1.day.ago }
      visible_until_at { 1.day.from_now }
    end
  end
end
