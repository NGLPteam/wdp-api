# frozen_string_literal: true

FactoryBot.define do
  factory :schema_definition do
    name { Faker::Commerce.unique.product_name }
    identifier { Faker::Commerce.unique.product_name }
    kind { "metadata" }

    trait :collection do
      kind { "collection" }
    end

    trait :item do
      kind { "item" }
    end

    trait :metadata do
      kind { "metadata" }
    end
  end
end
