# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_metadata_mapping do
    association :harvest_source

    field { :identifier }

    sequence(:pattern) { "^some-pattern-#{_1}" }

    target_entity { FactoryBot.create :collection }
  end
end
