FactoryBot.define do
  factory :user do
    keycloak_id { SecureRandom.uuid }

    email { Faker::Internet.safe_email }
    email_verified { true }

    username { Faker::Internet.username }
    name { "#{given_name} #{family_name}" }

    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }

    roles { [] }
    resource_roles { {} }
    metadata { {} }
  end
end
