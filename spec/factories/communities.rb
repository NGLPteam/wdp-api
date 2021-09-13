# frozen_string_literal: true

FactoryBot.define do
  factory :community do
    title { Faker::Commerce.product_name }

    schema_version { SchemaVersion.default_community }

    trait :with_thumbnail do
      thumbnail do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end
  end
end
