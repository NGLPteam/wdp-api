# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_set do
    harvest_source { nil }
    system_slug { "" }
    identifier { "MyText" }
    name { "" }
    description { "MyText" }
    metadata { "" }
  end
end
