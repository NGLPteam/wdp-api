# frozen_string_literal: true

module Layouts
  module DefinitionHierarchies
    # @see Layouts::DefinitionHierarchies::Upsert
    class Upserter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :layout_definition, Layouts::Types::LayoutDefinition
      end

      UNIQUE_BY = %i[layout_definition_type layout_definition_id].freeze

      delegate :id, to: :layout_definition, prefix: true

      delegate :entity, :layout_kind, :schema_version_id, to: :layout_definition

      delegate :auth_path, :id, to: :entity, prefix: true, allow_nil: true
      delegate :entity_type, to: :entity, allow_nil: true

      standard_execution!

      # @return [String]
      attr_reader :auth_path

      # @return ["root", "leaf"]
      attr_reader :kind

      # @return [LayoutDefinitionHierarchy]
      attr_reader :layout_definition_hierarchy

      # @return [String]
      attr_reader :layout_definition_type

      # @return [Hash]
      attr_reader :tuple

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield prepare!

          yield upsert!
        end

        Success layout_definition_hierarchy
      end

      wrapped_hook! def prepare
        @auth_path = entity_auth_path.presence || ""

        @kind = entity.present? ? "leaf" : "root"

        @layout_definition_type = layout_definition.model_name.to_s

        @tuple = {
          schema_version_id:,
          layout_definition_type:,
          layout_definition_id:,
          entity_id:,
          entity_type:,
          auth_path:,
          kind:,
          layout_kind:,
        }

        super
      end

      wrapped_hook! def upsert
        result = LayoutDefinitionHierarchy.upsert(tuple, unique_by: UNIQUE_BY, returning: :id)

        id = result.pick("id")

        @layout_definition_hierarchy = LayoutDefinitionHierarchy.find(id)

        super
      end
    end
  end
end
