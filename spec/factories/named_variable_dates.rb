# frozen_string_literal: true

FactoryBot.define do
  factory :named_variable_date do
    association :entity, factory: :collection
    schema_version_property { nil }
    path { "$published" }
    actual { VariablePrecisionDate.none }
  end
end
