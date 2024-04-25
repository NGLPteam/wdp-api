# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      acl { false }
      manager_on { nil }
      editor_on { nil }
      reader_on { nil }
    end

    keycloak_id { SecureRandom.uuid }

    email { Faker::Internet.safe_email }
    email_verified { false }

    username { email }
    name { "#{given_name} #{family_name}" }

    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }

    roles { [] }
    resource_roles { {} }
    metadata { { "testing" => true } }

    global_access_control_list do
      Roles::GlobalAccessControlList.build_with(acl).as_json
    end

    trait :admin do
      roles { ["global_admin"] }

      after(:create) do |user, evaluator|
        user.enforce_assignments!

        user.assign_global_permissions!
      end
    end

    trait :with_avatar do
      avatar do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end

    after(:create) do |user, evaluator|
      if evaluator.manager_on.present?
        MeruAPI::Container["access.grant"].call(Role.fetch(:manager), on: evaluator.manager_on, to: user)
      end

      if evaluator.editor_on.present?
        MeruAPI::Container["access.grant"].call(Role.fetch(:editor), on: evaluator.editor_on, to: user)
      end

      if evaluator.reader_on.present?
        MeruAPI::Container["access.grant"].call(Role.fetch(:reader), on: evaluator.reader_on, to: user)
      end
    end
  end
end
