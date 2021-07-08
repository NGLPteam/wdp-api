# frozen_string_literal: true

FactoryBot.define do
  factory :user_group_membership do
    association :user
    association :user_group
  end
end
