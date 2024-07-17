# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary do
    namespace { "meru.test" }
    identifier { "test" }
    sequence(:version) { "1.0.#{_1}" }
    provides { "unit" }
    name { "Test CV v#{version}" }

    trait :default_namespace do
      namespace { ControlledVocabulary::DEFAULT_NAMESPACE }
    end
  end
end
