# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_contribution do
    harvest_contributor { nil }
    harvest_entity { nil }
    kind { "" }
    metadata { "" }
  end
end
