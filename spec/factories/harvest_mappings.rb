# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_mapping do
    harvest_source { nil }
    harvest_set { nil }
    collection { nil }
    mode { "MyText" }
    frequency { "MyText" }
    frequency_expression { "MyText" }
    options { "" }
  end
end
