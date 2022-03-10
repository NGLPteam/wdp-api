# frozen_string_literal: true

module Schemas
  module Orderings
    # Middleware that can handle order refreshing and dictates rules about handling it performantly.
    #
    # It can be nested multiple times, but is additive only. Setting `disabled` to true in an outer scope
    # will make it always true, even if a later scope tries to override it.
    class RefreshStatus
      include Dry::Core::Memoizable
      include Dry::Effects.Resolve(:currently_harvesting)
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:refresh_orderings_asynchronously)
      include Dry::Effects.Resolve(:refresh_orderings_deferred)
      include Dry::Effects.Resolve(:refresh_orderings_disabled)
      include Dry::Effects.Resolve(:refresh_status)
      include Dry::Effects::Handler.Defer
      include Dry::Effects::Handler.Resolve

      include Dry::Initializer[undefined: false].define -> do
        option :async, Schemas::Types::Bool, as: :currently_async, default: proc { false }
        option :deferred, Schemas::Types::Bool, as: :currently_deferred, default: proc { false }
        option :disabled, Schemas::Types::Bool, as: :currently_disabled, default: proc { false }
        option :skip_entities, Models::Types::ModelList, default: proc { [] }
        option :skip_schemas, Models::Types::ModelList, default: proc { [] }
        option :skip_identifiers, Schemas::Types::Array.of(Schemas::Types::String), default: proc { [] }
      end

      # Provide the current ordering refresh configuration to a block
      #
      # @note There is special handling for the status that is explicitly marked
      #   as `deferred`, and not just inheriting that value from above. It will
      #   call `with_defer`, creating a pool to allow refreshes to delay invocation
      #   until this wrap exits.
      # @see https://dry-rb.org/gems/dry-effects/master/effects/defer/
      # @yield a block where {Schemas::Instances::RefreshOrderings} may be invoked
      # @yieldreturn [void]
      # @return [void]
      def wrap
        provide build_provisions do
          maybe_with_deferred do
            yield
          end
        end
      end

      # @param [ApplicationRecord] model
      def skip?(model)
        case model
        when ::HierarchicalEntity
          skip_entity? model
        when ::Ordering
          skip_ordering? model
        else
          false
        end
      end

      # @!attribute [r] asynchronous
      # @return [Boolean]
      memoize def asynchronous
        currently_async || inherit_async
      end

      alias asynchronous? asynchronous
      alias async? asynchronous

      # @!attribute [r] deferred
      # @return [Boolean]
      memoize def deferred
        currently_deferred || inherit_deferred
      end

      alias deferred? deferred

      # @!attribute [r] disabled
      # @return [Boolean]
      memoize def disabled
        currently_disabled || inherit_disabled
      end

      alias disabled? disabled

      # @!attribute [r] harvesting
      # @return [Boolean]
      memoize def harvesting
        inherit_harvesting
      end

      alias harvesting? harvesting

      # @!attribute [r] skipped_entities
      # @return [<HierarchicalEntity>]
      memoize def skipped_entities
        skip_entities | inherit_skip_entities
      end

      # @!attribute [r] skipped_identifiers
      # @return [<String>]
      memoize def skipped_identifiers
        skip_identifiers | inherit_skip_identifiers
      end

      # @!attribute [r] skipped_schemas
      # @return [<SchemaVersion>]
      memoize def skipped_schemas
        skip_schemas | inherit_skip_schemas
      end

      private

      def build_provisions
        {
          refresh_orderings_asynchronously: async?,
          refresh_orderings_deferred: deferred?,
          refresh_orderings_disabled: disabled?,
          refresh_skipped_entities: skipped_entities,
          refresh_skipped_schemas: skipped_schemas,
          refresh_skipped_identifiers: skipped_identifiers,
          refresh_status: self,
        }
      end

      # @return [Boolean]
      def inherit_async
        inherit_harvesting || refresh_orderings_asynchronously { false }
      end

      def inherit_deferred
        refresh_orderings_deferred { false }.present?
      end

      # @return [Boolean]
      def inherit_disabled
        refresh_orderings_disabled { false }.present?
      end

      def inherit_harvesting
        harvest_attempt { nil }.present? || currently_harvesting { false }.present?
      end

      # @return [<HierarchicalEntity>]
      def inherit_skip_entities
        Array(parent_status&.skipped_entities)
      end

      def inherit_skip_identifiers
        Array(parent_status&.skipped_identifiers)
      end

      def inherit_skip_schemas
        Array(parent_status&.skipped_schemas)
      end

      # Wrap the provided block `with_defer` if this status is the specific
      # one set to be deferred.
      #
      # @return [void]
      def maybe_with_deferred
        return yield unless currently_deferred

        with_defer executor: :fast do
          yield
        end
      end

      # @return [Schemas::Orderings::RefreshStatus, nil]
      def parent_status
        refresh_status { nil }
      end

      # @param [HierarchicalEntity] entity
      def skip_entity?(entity)
        entity.in? skipped_entities
      end

      # @param [Ordering] ordering
      def skip_ordering?(ordering)
        skip_ordering_by_identifier?(ordering) || skip_ordering_by_entity?(ordering) || skip_ordering_by_schema?(ordering)
      end

      # @param [Ordering] ordering
      def skip_ordering_by_entity?(ordering)
        ordering.entity.in? skipped_entities
      end

      # @param [Ordering] ordering
      def skip_ordering_by_identifier?(ordering)
        ordering.identifier.in? skipped_identifiers
      end

      # @param [Ordering] ordering
      def skip_ordering_by_schema?(ordering)
        ordering.inherited_from_schema? && ordering.schema_version.in?(skipped_schemas)
      end
    end
  end
end
