# frozen_string_literal: true

FactoryBot.define do
  factory :ordering do
    entity { FactoryBot.create :collection }
    schema_version { entity.schema_version }
    identifier { Faker::Lorem.words(number: 2).join(?_) }

    definition do
      {
        id: identifier,
        name: identifier.titleize,
        select: { direct: "children" },
        order: [
          { path: "entity.updated_at", direction: "desc", nulls: "last" }
        ]
      }
    end

    trait :collection do
      entity { FactoryBot.create :collection }
    end

    trait :community do
      entity { FactoryBot.create :community }
    end

    trait :item do
      entity { FactoryBot.create :item }
    end

    trait :by_descending_title do
      after(:build) do |ordering|
        definition = ordering.definition.as_json

        definition["order"] = [
          { path: "entity.title", direction: "desc", nulls: "last" }
        ]

        ordering.definition = definition
      end
    end
  end
end
