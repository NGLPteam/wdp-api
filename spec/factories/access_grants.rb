# frozen_string_literal: true

FactoryBot.define do
  factory :access_grant do
    accessible { FactoryBot.create :community }
    association :role, :reader
    subject { FactoryBot.create(:user) }
  end
end
