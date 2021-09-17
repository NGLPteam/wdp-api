# frozen_string_literal: true

FactoryBot.define do
  factory :schematic_collected_reference do
    referrer { FactoryBot.create :item }
    referent { FactoryBot.create :contributor, :person }
    path { "some.path" }
    position { 1 }

    trait :from_community do
      referrer { FactoryBot.create :community }
    end

    trait :from_collection do
      referrer { FactoryBot.create :collection }
    end

    trait :from_item do
      referrer { FactoryBot.create :item }
    end

    trait :to_asset do
      referent { FactoryBot.create :asset }
    end

    trait :to_contributor do
      referent { FactoryBot.create :contributor, :person }
    end
  end
end
