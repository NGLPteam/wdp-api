# frozen_string_literal: true

module Testing
  class ScaffoldItem
    extend Dry::Initializer

    include InitializerOptions
    prepend HushActiveRecord

    option :collection, AppTypes.Instance(Collection)
    option :parent, AppTypes.Instance(Item).optional, default: proc {}
    option :schema_definition, AppTypes.Instance(SchemaDefinition).optional, default: proc { SchemaDefinition.default_item }
    option :child_count, AppTypes::Integer, default: proc { 3 }
    option :grandchild_count, AppTypes::Integer, default: proc { 2 }
    option :depth, AppTypes::Integer, default: proc { 0 }

    def call
      attributes = initializer_options.slice(:collection, :parent, :schema_definition).compact

      item = FactoryBot.create :item, attributes

      attach_contributors_to! item

      child_scaffolder = Testing::ScaffoldItem.new(child_options_for(item))

      child_count.times do
        child_scaffolder.call
      end

      return item
    end

    private

    def attach_contributors_to!(item)
      attach_contributors_from!(Contributor.organization.sample(2), item)
      attach_contributors_from!(Contributor.person.sample(2), item)
    end

    def attach_contributors_from!(contributors, item)
      contributors.each do |contributor|
        WDPAPI::Container["contributors.attach_item"].call(contributor, item)
      end
    end

    def child_options_for(parent)
      initializer_options.dup.merge(parent: parent).tap do |h|
        h[:child_count] = h[:grandchild_count]
        h[:grandchild_count] = 0
        h[:depth] += 1
      end
    end
  end
end
