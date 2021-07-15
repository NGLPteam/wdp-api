# frozen_string_literal: true

FactoryBot.define do
  factory :community do
    title { Faker::Commerce.product_name }
  end
end
