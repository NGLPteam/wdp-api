FactoryBot.define do
  factory :schema_version do
    association :schema_definition
  end
end
