# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_attempt do
    transient do
      max_records { 5000 }
    end

    association :harvest_source
    target_entity { create :collection }
    harvest_set { nil }
    harvest_mapping { nil }

    kind { "manual" }
    metadata_format { "mods" }

    description { "A test harvesting attempt" }

    metadata do
      {
        max_records: max_records,
      }
    end

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
