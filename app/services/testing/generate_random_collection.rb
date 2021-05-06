# frozen_string_literal: true

module Testing
  class GenerateRandomCollection
    extend Dry::Initializer

    option :items_count, AppTypes::Integer, default: proc { 20 }

    def call
      title = Faker::Lorem.words(number: 5..7).join(" ").titleize

      collection = Collection.new title: title, description: generate_description

      collection.save!

      items_count.times do
        build_item_for collection
      end

      return collection
    end

    private

    def build_item_for(collection)
      collection.items.create!(
        title: Faker::Commerce.unique.product_name,
        description: generate_description
      )
    end

    def generate_description
      Faker::Lorem.paragraphs(number: 4..10).join(" ")
    end
  end
end
