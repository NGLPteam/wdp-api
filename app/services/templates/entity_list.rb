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
      option :fallback, Templates::Types::Bool, default: proc { false }
    end

    delegate :each, to: :valid_entities

    alias fallback? fallback

    alias records entities

    # @return [Integer]
    attr_reader :count

    alias size count

    # @return [Boolean]
    attr_reader :empty

    alias empty? empty

    # @return [<Layouts::ListItemInstance>]
    attr_reader :list_item_layouts

    # {#entities} that have valid list item layouts.
    #
    # It's possible for very new entities that have just been harvested
    # to not have layouts yet, and we want to skip those entirely.
    #
    # @return [<HierarchicalEntity>]
    attr_reader :valid_entities

    def initialize(...)
      super

      load_list_item_layouts!

      @valid_entities = entities.select { _1.list_item_layout_instance.present? }

      @list_item_layouts = valid_entities.map(&:list_item_layout_instance).compact

      @count = valid_entities.size

      @empty = valid_entities.blank?
    end

    private

    # @return [Array]
    def build_associations
      fetch_or_store :built_associations do
        template_instance = list_item_template_instances = [
          :entity,
          :template_definition,
        ].freeze

        [
          {
            list_item_layout_instance: [
              :entity,
              :layout_definition,
              {
                template_instance:,
                list_item_template_instances:,
              }
            ],
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
