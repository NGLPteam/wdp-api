# frozen_string_literal: true

FactoryBot.define do
  factory :community do
    transient do
      schema { nil }
    end

    title { Faker::Commerce.product_name }

    schema_version { schema.present? ? SchemaVersion[schema] : SchemaVersion.default_community }

    trait :with_thumbnail do
      thumbnail do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end
  end
end
