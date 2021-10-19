# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      acl { false }
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
    end

    trait :all_access do
      acl { true }
    end

    trait :communities_access do
      acl { { communities: true } }
    end

    trait :settings_access do
      acl { { settings: true } }
    end

    trait :users_access do
      acl { { users: true } }
    end
  end
end
