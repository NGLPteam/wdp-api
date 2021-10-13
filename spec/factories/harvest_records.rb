# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_record do
    harvest_attempt { nil }
    identifier { "MyText" }
    metadata_kind { "MyText" }
    entity_count { "" }
    raw_source { "MyText" }
    raw_header_source { "MyText" }
    raw_metadata_source { "MyText" }
    local_metadata { "" }
  end
end
