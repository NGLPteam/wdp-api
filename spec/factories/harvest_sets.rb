# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_set do
    harvest_source { nil }
    sequence(:identifier) do |n|
      "hs-#{n}"
    end

    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    raw_source { "" }
    metadata { {} }
  end
end
