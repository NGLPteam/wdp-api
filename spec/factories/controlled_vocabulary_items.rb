# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary_item do
    association(:controlled_vocabulary)

    identifier { Faker::Lorem.unique.sentence.parameterize }

    label { identifier.titleize }
  end
end
