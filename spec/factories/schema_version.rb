# frozen_string_literal: true

FactoryBot.define do
  factory :schema_version do
    transient do
      number { "1.0.0" }
    end

    association :schema_definition

    configuration do
      {
        namespace: schema_definition.namespace,
        identifier: schema_definition.identifier,
        name: schema_definition.name,
        version: number,
        kind: schema_definition.kind,
        orderings: [],
        properties: []
      }
    end

    trait :community do
      association :schema_definition, :for_community
    end

    trait :collection do
      association :schema_definition, :for_collection
    end

    trait :item do
      association :schema_definition, :for_item
    end

    %i[community collection item].each do |type|
      simple = :"simple_#{type}"

      trait simple do
        association :schema_definition, simple

        configuration do
          testing_schema_configuration_for simple, number
        end
      end

      if type == :collection
        required = :"required_#{type}"

        trait required do
          association :schema_definition, required

          configuration do
            testing_schema_configuration_for required, number
          end
        end
      end
    end

    trait :v1 do
      number { "1.0.0" }
    end

    trait :v2 do
      number { "2.0.0" }
    end

    # upsert the instance instead
    to_create do |instance|
      declaration = instance.configuration.declaration

      existing = SchemaVersion.filtered_by(declaration).first

      if existing.present?
        existing.configuration = instance.configuration.as_json

        existing.configuration_will_change!

        existing.save!

        instance.id = existing.id
      else
        instance.save!
      end

      instance.reload
    end
  end
end
