# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::RenderSlots
    class SlotsRenderer < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_definition, Templates::Types::TemplateDefinition

        param :entity, Templates::Types::Entity

        option :force, Types::Bool, default: proc { false }
      end

      delegate :slots, to: :template_definition, prefix: :definition
      delegate :instance_slots_klass, to: :definition_slots

      standard_execution!

      # @return [{ String => Object }]
      attr_reader :assigns

      # @return [Templates::SlotMappings::AbstractInstanceSlots]
      attr_reader :mapping

      # @return [{ Symbol => Object }]
      attr_reader :slots

      # @return [Dry::Monads::Success(Templates::SlotMappings::AbstractInstanceSlots)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield render_each_slot!

          yield finalize!
        end

        Success mapping
      end

      wrapped_hook! def prepare
        @assigns = yield entity.to_liquid_assigns

        @slots = {}

        @mapping = nil

        super
      end

      wrapped_hook! def render_each_slot
        definition_slots.each do |name, slot|
          next if slot.blank?

          slots[name] = slot.render(assigns:, force:).value_or(nil)
        end

        slots.compact_blank!

        super
      end

      wrapped_hook! def finalize
        @mapping = instance_slots_klass.new(slots)

        super
      end
    end
  end
end
