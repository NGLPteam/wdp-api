# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_source do
    name { "A Harvest Source" }
    description { "A Harvest Source" }
    base_url { "https://example.com" }
    protocol { "oai" }
    metadata_format { "mods" }

    trait :oai do
      protocol { "oai" }
    end

    trait :jats do
      metadata_format { "jats" }
    end

    trait :mods do
      metadata_format { "mods" }
    end
  end
end
