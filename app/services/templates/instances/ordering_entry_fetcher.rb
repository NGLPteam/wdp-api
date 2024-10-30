# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::FetchOrderingEntry
    class OrderingEntryFetcher < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_instance, Templates::Types::TemplateInstance
      end

      delegate :template_definition, to: :template_instance

      delegate :ordering_identifier, to: :template_definition

      standard_execution!

      # @return [Ordering, nil]
      attr_reader :ordering

      delegate :id, to: :ordering, prefix: true, allow_nil: true

      # @return [OrderingEntry, nil]
      attr_reader :ordering_entry

      # @return [String, nil]
      attr_reader :ordering_entry_id

      # @return [HierarchicalEntity, nil]
      attr_reader :ordering_source

      # @return [HierarchicalEntity, nil]
      attr_reader :selection_source

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield prepare!

          yield find_entry!

          yield persist!
        end

        Success ordering_entry
      end

      wrapped_hook! def prepare
        @ordering = nil
        @ordering_entry = nil
        @ordering_source = template_instance.resolve_ordering_source.value_or(nil)
        @selection_source = template_instance.resolve_selection_source.value_or(nil)

        super
      end

      wrapped_hook! def find_entry
        return super if ordering_source.blank? || selection_source.blank?

        @ordering = ordering_source.ordering(ordering_identifier)

        @ordering_entry = ordering_source.find_ordering_entry(ordering_identifier, selection_source).value_or(nil)

        @ordering_entry_id = ordering_entry&.read_attribute(:id)

        super
      end

      wrapped_hook! def persist
        template_instance.update_columns(ordering_id:, ordering_entry_id:)

        super
      end
    end
  end
end
