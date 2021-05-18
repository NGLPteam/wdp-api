# frozen_string_literal: true

FactoryBot.define do
  factory :token_payload, class: Hash do
    transient do
      realm_roles { ["foo"] }
      widget_roles { ["bar"] }
    end

    aud { "keycloak" }
    azp { "keycloak" }
    nonce { SecureRandom.uuid }
    session_state { SecureRandom.uuid }
    allowed_origins { ["http://example.com"] }

    sub { SecureRandom.uuid }
    realm_access { { "roles" => Array(realm_roles) } }
    resource_access do
      { "widgets" => { "roles" => Array(widget_roles) } }
    end
    scope { "openid" }

    email_verified { true }
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    name { "#{given_name} #{family_name}" }
    preferred_username do
      Faker::Internet.username specifier: "#{given_name}.#{family_name}"
    end
    email { Faker::Internet.safe_email name: name }

    custom_attribute { "custom_value" }

    initialize_with do
      Hash(attributes).tap do |h|
        h["allowed-origins"] = Array(h.delete("allowed_origins"))
      end
    end
  end
end
