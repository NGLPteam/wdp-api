# frozen_string_literal: true

module OrderingInvalidations
  # Given an {OrderingInvalidation}, grab its associated {Ordering} and refresh.
  #
  # @see OrderingInvalidations::Process
  # @see OrderingInvalidations::ProcessAllJob
  class Processor < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :ordering_invalidation, Types::OrderingInvalidation
    end

    standard_execution!

    delegate :id, :ordering_id, :stale_at, to: :ordering_invalidation

    # @return [Ordering]
    attr_reader :ordering

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield refresh!

        yield prune!
      end

      Success()
    end

    wrapped_hook! def prepare
      @ordering = ordering_invalidation.reload_ordering

      super
    end

    wrapped_hook! def refresh
      yield ordering.refresh

      super
    end

    wrapped_hook! def prune
      OrderingInvalidation.where(ordering_id:).stale_before(stale_at).delete_all

      OrderingInvalidation.delete(id)

      super
    end
  end
end
