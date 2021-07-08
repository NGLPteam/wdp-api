# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    transient do
      actions { [] }
    end

    name { Faker::Lorem.unique.word }

    trait :reader do
      access_control_list { Roles::AccessControlList.build_with(read: true).as_json }
    end

    trait :editor do
      access_control_list { Roles::AccessControlList.build_with(true).as_json }
    end
  end
end
