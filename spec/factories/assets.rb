# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    attachable { FactoryBot.create :item }

    attachment do
      Rails.root.join("spec", "data", "lorempixel.jpg").open
    end

    name { Faker::Lorem.sentence }

    trait :from_community do
      attachable { FactoryBot.create :community }
    end

    trait :from_collection do
      attachable { FactoryBot.create :collection }
    end

    trait :from_item do
      attachable { FactoryBot.create :item }
    end

    trait :image do
      attachment do
        Rails.root.join("spec", "data", "lorempixel.jpg").open
      end
    end

    trait :audio do
      attachment do
        Rails.root.join("spec", "data", "sample.mp3").open
      end
    end

    trait :pdf do
      attachment do
        Rails.root.join("spec", "data", "sample.pdf").open
      end
    end

    trait :video do
      attachment do
        Rails.root.join("spec", "data", "sample.mp4").open
      end
    end

    trait :document do
      attachment do
        Rails.root.join("spec", "data", "sample.txt").open
      end
    end
  end
end
