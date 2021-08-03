# frozen_string_literal: true

FactoryBot.define do
  factory :schematic_scalar_reference do
    referrer { nil }
    referent { nil }
    path { "" }
  end
end
