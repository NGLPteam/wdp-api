# frozen_string_literal: true

FactoryBot.define do
  factory :entity_link do
    source { FactoryBot.create :item }
    target { FactoryBot.create :item }
    operator { :contains }

    trait :contains do
      operator { :contains }
    end

    trait :references do
      operator { :references }
    end

    trait :from_community do
      source { FactoryBot.create :community }
    end

    trait :from_collection do
      source { FactoryBot.create :collection }
    end

    trait :from_item do
      source { FactoryBot.create :item }
    end

    trait :to_community do
      target { FactoryBot.create :community }
    end

    trait :to_collection do
      target { FactoryBot.create :collection }
    end

    trait :to_item do
      target { FactoryBot.create :item }
    end
  end
end
