# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::MaintainManualList
    class ManualListMaintainer < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :definition, Templates::Types::TemplateDefinition
      end

      delegate :manual_selection_mode?,
        :manual_list_name,
        :manual_list_name?,
        :layout_definition,
        :layout_kind,
        :template_kind,
        to: :definition

      alias list_name manual_list_name

      standard_execution!

      # @return [Templates::ManualList]
      attr_reader :manual_list

      # @return [Boolean]
      attr_reader :should_have_list

      alias should_have_list? should_have_list

      # @return [Dry::Monads::Success(Templates::ManualList)]
      # @return [Dry::Monads::Success(nil)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield maintain!
        end

        Success manual_list
      end

      wrapped_hook! def prepare
        @manual_list = definition.reload_manual_list

        @should_have_list = manual_selection_mode? && manual_list_name?

        super
      end

      wrapped_hook! def maintain
        if should_have_list?
          yield enforce_list!
        else
          yield maybe_prune_list!
        end

        super
      end

      wrapped_hook! def enforce_list
        @manual_list ||= definition.build_manual_list

        manual_list.assign_attributes(
          layout_definition:,
          layout_kind:,
          list_name:,
          template_kind:,
        )

        # This should never fail at runtime.
        manual_list.save!

        super
      end

      wrapped_hook! def maybe_prune_list
        # This should never fail at runtime.
        @manual_list&.destroy!

        @manual_list = nil

        super
      end
    end
  end
end
