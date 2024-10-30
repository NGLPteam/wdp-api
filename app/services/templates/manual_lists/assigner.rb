# frozen_string_literal: true

module Templates
  module ManualLists
    # @see Templates::ManualLists::Assign
    class Assigner < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :source, Templates::Types::ManualListSource

        option :list_name, Templates::Types::SchemaComponent
        option :targets, Templates::Types::ManualListTargets, default: proc { EMPTY_ARRAY }
        option :template_kind, Templates::Types::Kind
      end

      standard_execution!

      # @return [{ Symbol => Object }]
      attr_reader :base_tuple

      # @return [Integer]
      attr_reader :entry_count

      # @return [ActiveRecord::Relation<Templates::ManualListEntry>]
      attr_reader :entry_scope

      # @return [<Templates::ManualListEntry>]
      attr_reader :list_entries

      # @return [Integer]
      attr_reader :pruned_count

      # @return [Dry::Monads::Success{ Symbol => Integer }]
      def call
        run_callbacks :execute do
          yield prepare!

          yield populate!

          yield prune!
        end

        counts = { entry_count:, pruned_count:, }

        Success counts
      end

      wrapped_hook! def prepare
        @base_tuple = { source:, list_name:, template_kind:, }.freeze

        @entry_scope = ::Templates::ManualListEntry.where(base_tuple)

        @list_entries = []

        @entry_count = 0

        @pruned_count = 0

        super
      end

      wrapped_hook! def populate
        clean_targets = targets.uniq.without(source).map do |target|
          case target
          when ::EntityLink then target.target
          else
            target
          end
        end

        clean_targets.each_with_index do |target, index|
          position = index + 1

          entry = entry_scope.where(target:).first_or_initialize

          entry.assign_attributes(position:)

          entry.save!

          list_entries << entry
        end

        @entry_count = list_entries.size

        super
      end

      wrapped_hook! def prune
        id = list_entries.map(&:id)

        @pruned_count = entry_scope.where.not(id:).delete_all

        super
      end
    end
  end
end
