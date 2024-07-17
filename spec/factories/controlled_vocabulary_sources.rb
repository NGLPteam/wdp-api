# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary_source do
    controlled_vocabulary { nil }
    provides { "test_units" }
  end
end
