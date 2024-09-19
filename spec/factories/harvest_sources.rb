# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_source do
    transient do
      link_identifiers_globally { false }
      use_metadata_mappings { false }
      max_records { Harvesting::ABSOLUTE_MAX_RECORD_COUNT }
    end

    sequence(:identifier) do |n|
      "source-#{n}"
    end

    sequence(:name) do |n|
      "Harvest Source #{n}"
    end

    description { "A Test Harvest Source" }
    base_url { "https://example.com/oai" }
    protocol { "oai" }
    metadata_format { "mods" }

    mapping_options do
      {
        link_identifiers_globally:,
        use_metadata_mappings:,
      }
    end

    read_options do
      {
        max_records:,
      }
    end

    trait :oai do
      protocol { "oai" }
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
