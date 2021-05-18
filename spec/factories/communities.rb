FactoryBot.define do
  factory :community do
    name { Faker::Commerce.product_name }
  end
end
