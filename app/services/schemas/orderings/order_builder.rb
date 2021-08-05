# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      extend Dry::Container::Mixin

      class << self
        # @param [<Schemas::Ordering::OrderDefinitions>] definitions
        def call(definitions)
          Array(definitions).reduce([]) do |acc, definition|
            acc.concat compile definition
          end
        end

        # @param [Schemas::Ordering::OrderDefinitions] definition
        def compile(definition)
          self[definition.query_builder_key].call(definition)
        end
      end

      namespace :entity do
        register :created_at do
          ByColumns.new(columns: :entity_created_at)
        end

        register :updated_at do
          ByColumns.new(columns: :entity_updated_at)
        end

        register :published_on do
          ByColumns.new(columns: :entity_published_on)
        end

        register :title do
          ByColumns.new(columns: :entity_title)
        end

        register :depth do
          ByColumns.new(columns: :entity_depth)
        end
      end

      namespace :link do
        register :operator do
          ByColumns.new(columns: :link_operator)
        end
      end

      namespace :schema do
        register :consumer do
          ByColumns.new(columns: :schema_consumer)
        end

        register :identifier do
          ByColumns.new(columns: :schema_identifier)
        end

        register :name do
          ByColumns.new(columns: :schema_name)
        end

        register :namespace do
          ByColumns.new(columns: :schema_namespace)
        end

        register :namespaced_version do
          ByColumns.new(columns: %i[schema_namespace schema_parsed_number])
        end

        register :version do
          ByColumns.new(columns: %i[schema_parsed_number])
        end
      end

      STATIC_KEYS = Regexp.union(keys)

      PATTERN = /\A
      (?:#{STATIC_KEYS})
      |
      (?:props\.(?:[^\.]+)(?:\.[^\.]+)?)
      \z/xms.freeze

      namespace :props do
        register ?* do
          BySchemaProperty.new
        end
      end
    end
  end
end
