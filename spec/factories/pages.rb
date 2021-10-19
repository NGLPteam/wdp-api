# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    entity { FactoryBot.create(:collection) }
    position { 1 }
    title { Faker::Lorem.unique.words(number: 7).join(" ").titlecase }
    slug { title.parameterize }
    body { Faker::Lorem.paragraph }

    trait :from_collection do
      entity { FactoryBot.create :collection }
    end

    trait :from_item do
      entity { FactoryBot.create :item }
    end

    trait :with_hero_image do
      hero_image do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end

    trait :existing do
      title { "Existing" }
      slug { "existing" }
    end
  end
end
