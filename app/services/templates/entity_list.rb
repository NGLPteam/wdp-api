# frozen_string_literal: true

module Templates
  # A deterministically-ordered list of entities that can be rendered
  # within a {TemplateInstance}.
  #
  # @see Templates::Instances::FetchEntityList
  # @see Templates::Instances::EntityListFetcher
  # @see Types::TemplateEntityListType
  # @see Types::TemplateHasEntityListType
  class EntityList
    extend Dry::Core::Cache

    include Enumerable
    include Dry::Core::Constants
    include Dry::Core::Equalizer.new(:entities)
    include Dry::Initializer[undefined: false].define -> do
      option :entities, Templates::Types::Entities, default: proc { EMPTY_ARRAY }
    end

    delegate :each, to: :entities

    alias records entities

    # @return [Integer]
    attr_reader :count

    alias size count

    # @return [Boolean]
    attr_reader :empty

    alias empty? empty

    # @return [<Layouts::ListItemInstance>]
    attr_reader :list_item_layouts

    def initialize(...)
      super

      load_list_item_layouts!

      @list_item_layouts = entities.map(&:list_item_layout_instance)

      @count = entities.size

      @empty = entities.blank?
    end

    private

    # @return [Array]
    def build_associations
      fetch_or_store :built_associations do
        template_instance = list_item_template_instances = [
          :entity,
          {
            template_definition: [
              :entity
            ],
          },
        ].freeze

        [
          {
            list_item_layout_instance: {
              entity: true,
              layout_definition: {
                entity: true
              },
              template_instance:,
              list_item_template_instances:,
            }
          }
        ].freeze
      end
    end

    # @return [void]
    def load_list_item_layouts!
      associations = build_associations

      preloader = ActiveRecord::Associations::Preloader.new(records:, associations:)

      preloader.call
    end
  end
end
