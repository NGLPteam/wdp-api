# frozen_string_literal: true

FactoryBot.define do
  factory :contributor do
    identifier { SecureRandom.uuid }

    email { Faker::Internet.safe_email }
    url { Faker::Internet.url }
    bio { Faker::Lorem.paragraphs(number: 4).join("\n") }
    orcid { nil }

    links do
      [{ url: Faker::Internet.url, title: Faker::Lorem.sentence }]
    end

    trait :organization do
      transient do
        legal_name { Faker::Company.name }
        location { Faker::Address.full_address }
      end

      kind { :organization }

      properties do
        {
          organization: {
            legal_name: legal_name,
            location: location
          }
        }
      end
    end

    trait :person do
      transient do
        given_name { Faker::Name.first_name }
        family_name { Faker::Name.last_name }
        title { Faker::Name.prefix }
        affiliation { Faker::Company.name }
      end

      kind { :person }

      properties do
        {
          person: {
            given_name: given_name,
            family_name: family_name,
            title: title,
            affiliation: affiliation
          }
        }
      end
    end

    trait :with_image do
      image do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end
  end
end
