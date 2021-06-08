# frozen_string_literal: true

module Testing
  class ScaffoldCommunity
    extend Dry::Initializer

    include InitializerOptions
    prepend HushActiveRecord

    option :collections_count, AppTypes::Integer, default: proc { 3 }, reader: :private
    option :child_count, AppTypes::Integer, default: proc { 3 }
    option :grandchild_count, AppTypes::Integer, default: proc { 2 }
    option :items_count, AppTypes::Integer, default: proc { 5 }

    def call
      community = FactoryBot.create :community

      collection_options = initializer_options.merge(community: community)

      collection_builder = Testing::ScaffoldCollection.new collection_options

      collections_count.times do
        collection_builder.call
      end

      return community
    end
  end
end
