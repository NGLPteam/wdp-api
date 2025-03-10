# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_message do
    at { Faker::Time.backward }

    message { Faker::Lorem.sentence }
  end
end
