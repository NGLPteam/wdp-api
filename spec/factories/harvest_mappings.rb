# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_mapping do
    transient do
      link_identifiers_globally { false }
      max_records { 5000 }
    end

    association :harvest_source
    harvest_set { nil }
    target_entity { create :collection }
    mode { "manual" }
    metadata_format { "mods" }

    mapping_options do
      {
        link_identifiers_globally: link_identifiers_globally,
      }
    end

    read_options do
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

    trait :global_identifiers do
      link_identifiers_globally { true }
    end
  end
end
