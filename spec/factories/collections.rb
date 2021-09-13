# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    association :community

    schema_version { SchemaVersion.default_collection }

    title { Faker::Lorem.sentence }
    identifier { title.parameterize }

    doi { SecureRandom.uuid }
    summary { Faker::Lorem.paragraph }

    published_on { Faker::Date.backward }

    visibility { :visible }

    trait :hidden do
      visibility { :hidden }
    end

    trait :limited do
      visibility { :limited }

      visible_after_at { 1.day.ago }
      visible_until_at { 1.day.from_now }
    end

    trait :with_thumbnail do
      thumbnail do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end
  end
end
