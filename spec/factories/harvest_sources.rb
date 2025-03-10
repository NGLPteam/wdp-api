# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_source do
    transient do
      link_identifiers_globally { false }
      use_metadata_mappings { false }
      max_records { Harvesting::ABSOLUTE_MAX_RECORD_COUNT }
    end

    testing_provider { Harvesting::Testing::ProviderDefinition.oai.first }

    sequence(:identifier) do |n|
      "source-#{n}"
    end

    sequence(:name) do |n|
      "Harvest Source #{n}"
    end

    description { "A Test Harvest Source" }

    protocol { testing_provider.protocol_name }
    metadata_format { testing_provider.metadata_format_name }

    base_url { testing_provider.oai_endpoint }
    extraction_mapping_template do
      testing_provider.extraction_mapping_template
    end

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
      oai

      testing_provider do
        Harvesting::Testing::ProviderDefinition.oai.jats.first
      end

      metadata_format { "jats" }
    end

    trait :global_identifiers do
      link_identifiers_globally { true }
    end

    trait :broken_oai do
      oai
      jats
      testing_provider { nil }
      extraction_mapping_template do
        Harvesting::Example.find("empty").extraction_mapping_template
      end
      base_url { ::Harvesting::Testing::OAI::Broken::Provider::ENDPOINT }
      name { "Broken OAI Harvest Source" }
    end
  end
end
