# frozen_string_literal: true

FactoryBot.define do
  factory :announcement do
    entity { FactoryBot.create(:collection) }

    published_on { Date.current }

    header { Faker::Lorem.unique.words(number: 7).join(" ").titlecase }
    teaser { Faker::Lorem.paragraph }
    body { Faker::Lorem.paragraph }

    trait :from_collection do
      entity { FactoryBot.create :collection }
    end

    trait :from_item do
      entity { FactoryBot.create :item }
    end

    trait :today do
      published_on { Date.current }
    end

    trait :yesterday do
      published_on { Date.current.yesterday }
    end

    trait :a_week_ago do
      published_on { 1.week.ago }
    end
  end
end
