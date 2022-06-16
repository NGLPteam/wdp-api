# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_entity do
    association :harvest_record
    schema_version { SchemaVersion.default_collection }
    sequence(:identifier) { |i| "ent-#{i}" }

    entity { nil }

    metadata_kind { "anything" }

    extracted_properties { {} }
  end
end
