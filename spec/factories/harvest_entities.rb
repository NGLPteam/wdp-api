# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_entity do
    harvest_record { nil }
    entity { nil }
    schema_version { nil }
    identifier { "MyText" }
    metadata_kind { "MyText" }
    extracted_properties { "" }
  end
end
