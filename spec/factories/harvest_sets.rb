# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_set do
    association(:harvest_source)

    sequence(:identifier) do |n|
      "hs-#{n}"
    end

    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    raw_source { "" }
    metadata { {} }
  end
end
