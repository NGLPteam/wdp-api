# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    association :community
    association :schema_definition, :collection

    title { Faker::Lorem.sentence }
    identifier { title.parameterize }

    doi { SecureRandom.uuid }
    summary { Faker::Lorem.paragraph }

    published_on { Faker::Date.backward }
  end
end
