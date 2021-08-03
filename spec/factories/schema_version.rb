# frozen_string_literal: true

FactoryBot.define do
  factory :schema_version do
    association :schema_definition

    number { "1.0.0" }

    configuration do
      {
        id: schema_definition.identifier,
        name: schema_definition.name,
        version: number,
        consumer: schema_definition.kind,
        orderings: [],
        properties: []
      }
    end
  end
end
