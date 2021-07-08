# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    association :collection
    association :schema_definition, :item

    title { Faker::Lorem.sentence }
    identifier { title.parameterize }
    doi { SecureRandom.uuid }
    summary { Faker::Lorem.paragraph }

    published_on { Faker::Date.backward }
  end
end
