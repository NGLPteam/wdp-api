# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    transient do
      schema { nil }
    end

    association :community

    schema_version { schema.present? ? SchemaVersion[schema] : SchemaVersion.default_collection }

    title { Faker::Lorem.sentence }
    identifier { title.parameterize }

    doi { SecureRandom.uuid }
    summary { Faker::Lorem.paragraph }

    visibility { :visible }

    pending_properties { {} }

    trait :hidden do
      visibility { :hidden }
    end

    trait :limited do
      visibility { :limited }

      visible_after_at { 1.day.ago }
      visible_until_at { 1.day.from_now }
    end

    trait :with_hero_image do
      hero_image do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end

    trait :with_thumbnail do
      thumbnail do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end
  end
end
