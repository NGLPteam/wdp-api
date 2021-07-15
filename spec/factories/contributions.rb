# frozen_string_literal: true

FactoryBot.define do
  factory :collection_contribution do
    association :collection
    association :contributor
  end

  factory :item_contribution do
    association :contributor
    association :item
  end
end
