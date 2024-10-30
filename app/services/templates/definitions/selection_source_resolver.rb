# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::ResolveSelectionSource
    class SelectionSourceResolver < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :definition, Templates::Types::TemplateDefinition

        param :originating_entity, Templates::Types::Entity

        option :base_attr, Templates::Types::Coercible::Symbol, default: proc { :selection_source }
      end

      standard_execution!

      # @return [String, nil]
      attr_reader :ancestor_name

      # @return [String]
      attr_reader :selection_source

      # @return [Templates::Types::SelectionSourceMode]
      attr_reader :mode

      # @return [HierarchicalEntity]
      attr_reader :source_entity

      # @return [Dry::Monads::Success(HierarchicalEntity)]
      # @return [Dry::Monads::Failure(:no_selection_source, HierarchicalEntity, String)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield resolve!
        end

        Success source_entity
      end

      wrapped_hook! def prepare
        @selection_source = definition.__send__(base_attr)

        @ancestor_name = definition.__send__(:"#{base_attr}_ancestor_name")

        @mode = definition.__send__(:"#{base_attr}_mode")

        super
      end

      wrapped_hook! def resolve
        @source_entity = derive_source_entity

        return Failure[:no_selection_source, originating_entity, selection_source] if source_entity.blank?

        super
      end

      # @return [HierarchicalEntity, nil]
      def derive_source_entity
        case mode
        when "ancestor"
          originating_entity.ancestor_by_name(ancestor_name)
        when "parent"
          originating_entity.hierarchical_parent
        else
          originating_entity
        end
      end
    end
  end
end
