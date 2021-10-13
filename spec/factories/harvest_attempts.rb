# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_attempt do
    harvest_source { nil }
    harvest_set { nil }
    harvest_mapping { nil }
    collection { nil }
    system_slug { "MyText" }
    kind { "MyText" }
    description { "MyText" }
    record_count { "" }
    started_at { "2021-10-15 15:48:54" }
    completed_at { "2021-10-15 15:48:54" }
  end
end
