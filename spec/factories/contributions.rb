# frozen_string_literal: true

FactoryBot.define do
  factory :collection_contribution do
    association :collection
    association :contributor, :organization

    trait :organization do
      association :contributor, :organization
    end

    trait :person do
      association :contributor, :person
    end
  end

  factory :item_contribution do
    association :contributor, :organization
    association :item

    trait :organization do
      association :contributor, :organization
    end

    trait :person do
      association :contributor, :person
    end
  end
end
