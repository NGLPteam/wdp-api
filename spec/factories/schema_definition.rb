# frozen_string_literal: true

FactoryBot.define do
  factory :schema_definition do
    name { Faker::Commerce.unique.product_name }
    namespace { "testing" }
    identifier { name.parameterize.underscore }

    kind { "community" }

    trait :testing do
      namespace { "testing" }
    end

    trait :for_community do
      kind { "community" }
    end

    trait :for_collection do
      kind { "collection" }
    end

    trait :for_item do
      kind { "item" }
    end

    trait :cvocab_collection do
      for_collection

      testing

      identifier { "cvocab_collection" }

      name { "CVocab Testing Collection" }
    end

    trait :required_collection do
      for_collection

      testing

      identifier { "required_collection" }

      name { "Collection (with Required Props)" }
    end

    trait :simple_community do
      for_community

      testing

      identifier { "simple_community" }

      name { "Simple Community" }
    end

    trait :simple_collection do
      for_collection

      testing

      identifier { "simple_collection" }

      name { "Simple Collection" }
    end

    trait :simple_item do
      for_item

      testing

      identifier { "simple_item" }

      name { "Simple Item" }
    end

    # upsert the instance instead
    to_create do |instance|
      attrs = instance.slice(:namespace, :name, :identifier, :kind)

      res = SchemaDefinition.upsert attrs, unique_by: %i[identifier namespace], returning: :id

      id = res.first["id"]

      instance.id = id

      instance.reload
    end
  end
end
