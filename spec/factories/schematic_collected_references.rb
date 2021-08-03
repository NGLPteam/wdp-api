# frozen_string_literal: true

FactoryBot.define do
  factory :schematic_collected_reference do
    referrer { nil }
    referent { nil }
    path { "" }
    position { 1 }
  end
end
