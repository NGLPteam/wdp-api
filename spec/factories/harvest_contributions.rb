# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_contribution do
    association :harvest_contributor
    association :harvest_entity
    role { nil }
  end
end
