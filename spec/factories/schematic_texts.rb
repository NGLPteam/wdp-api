# frozen_string_literal: true

FactoryBot.define do
  factory :schematic_text do
    entity { FactoryBot.create :item }
    path { "some.path" }
    lang { nil }
    kind { "text" }
    content { Faker::Lorem.paragraphs(number: 10).join(" ") }

    trait :from_collection do
      entity { FactoryBot.create :collection }
    end

    trait :from_item do
      entity { FactoryBot.create :item }
    end

    trait :english do
      lang { "en" }

      content do
        <<~TEXT
        All human beings are born free and equal in dignity and rights. They are endowed with
        reason and conscience and should act towards one another in a spirit of brotherhood.
        TEXT
      end
    end
  end
end
