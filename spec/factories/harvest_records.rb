# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_record do
    association :harvest_attempt
    sequence(:identifier) do |n|
      "record-#{n}"
    end

    metadata_format { "mods" }
    entity_count { 0 }

    trait :jats do
      metadata_format { "jats" }
    end

    trait :mets do
      metadata_format { "mets" }
    end

    trait :mods do
      metadata_format { "mods" }
    end
  end
end
