# frozen_string_literal: true

module Testing
  class ScaffoldCollection
    extend Dry::Initializer

    include InitializerOptions

    option :community, AppTypes.Instance(Community).optional, default: proc { nil }
    option :parent, AppTypes.Instance(Collection).optional, default: proc { nil }
    option :schema_definition, AppTypes.Instance(SchemaDefinition).optional, default: proc { SchemaDefinition.default_collection }
    option :child_count, AppTypes::Integer, default: proc { 3 }
    option :grandchild_count, AppTypes::Integer, default: proc { 2 }
    option :depth, AppTypes::Integer, default: proc { 0 }
    option :items_count, AppTypes::Integer, default: proc { 5 }

    def call
      attributes = initializer_options.slice(:community, :parent, :schema_definition).compact

      collection = FactoryBot.create :collection, attributes

      attach_contributors_to! collection

      item_scaffolder = Testing::ScaffoldItem.new(item_options_for(collection))

      items_count.times do
        item_scaffolder.call
      end

      child_scaffolder = Testing::ScaffoldCollection.new(child_options_for(collection))

      child_count.times do
        child_scaffolder.call
      end

      return collection
    ensure
      Faker::UniqueGenerator.clear
    end

    private

    def attach_contributors_to!(collection)
      attach_contributors_from!(Contributor.organization.sample(2), collection)
      attach_contributors_from!(Contributor.person.sample(2), collection)
    end

    def attach_contributors_from!(contributors, collection)
      contributors.each do |contributor|
        WDPAPI::Container["contributors.attach_collection"].call(contributor, collection)
      end
    end

    def child_options_for(parent)
      initializer_options.merge(parent: parent).dup.tap do |h|
        h[:child_count] = h[:grandchild_count]
        h[:grandchild_count] = 0
        h[:depth] += 1
      end
    end

    def item_options_for(collection)
      initializer_options.without(:community, :parent, :schema_definition).merge(collection: collection, depth: 0)
    end
  end
end
