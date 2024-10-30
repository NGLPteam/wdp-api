# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::FetchEntityList
    class EntityListFetcher < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_instance, Templates::Types::TemplateInstance
      end

      delegate :template_definition, to: :template_instance

      delegate :selection_mode, to: :template_definition

      standard_execution!

      # @return [Templates::EntityList]
      attr_reader :entity_list

      # @return [String]
      attr_reader :operation_name

      # @return [HierarchicalEntity]
      attr_reader :source_entity

      # @return [Dry::Monads::Success(Templates::EntityList)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield resolve_source_entity!

          yield resolve_entity_list!
        end

        Success entity_list
      end

      # Initialize instance variables used here.
      #
      # @note Nil assignments are intentional owing to ruby internals:
      #   this service needs to be as efficient as possible.
      wrapped_hook! def prepare
        @entity_list = nil

        @source_entity = nil

        @operation_name = derive_entity_list_resolver_operation_name

        super
      end

      wrapped_hook! def resolve_source_entity
        @source_entity = yield template_instance.resolve_selection_source

        super
      end

      wrapped_hook! def resolve_entity_list
        props = template_definition.to_entity_list_resolution(source_entity:)

        @entity_list = yield call_operation(operation_name, **props)

        super
      end

      private

      def derive_entity_list_resolver_operation_name
        case selection_mode
        in "dynamic"
          "templates.entity_lists.resolve_dynamic"
        in "manual"
          "templates.entity_lists.resolve_manual"
        in "named"
          "templates.entity_lists.resolve_named"
        in "property"
          "templates.entity_lists.resolve_property"
        else
          # :nocov:
          raise "Unsupported Entity Resolution Mode: #{selection_mode}"
          # :nocov:
        end
      end
    end
  end
end
