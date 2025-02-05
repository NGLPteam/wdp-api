# frozen_string_literal: true

module Mutations
  # @api private
  # @see ModelMutationSupport
  # @see Mutations.with_active!
  class Active
    extend ActiveModel::Callbacks

    include Dry::Effects::Handler.Reader(:graphql_mutation_active)

    define_model_callbacks :wrap

    around_wrap :with_active_mutation!
    around_wrap :capture_related_invalidations!
    around_wrap :capture_syncs!

    # @return [Entities::Captors::RelatedInvalidations]
    attr_reader :related_invalidations_captor

    # @return [Entities::Captors::Syncs]
    attr_reader :sync_captor

    def initialize
      @related_invalidations_captor = Entities::Captors::RelatedInvalidations.new
      @sync_captor = Entities::Captors::Syncs.new
    end

    # @return [void]
    def wrap!
      run_callbacks :wrap do
        yield
      end
    end

    private

    def capture_related_invalidations!
      related_invalidations_captor.wrap! do
        yield
      end
    end

    # @return [void]
    def capture_syncs!
      sync_captor.wrap! do
        yield
      end
    end

    def with_active_mutation!
      with_graphql_mutation_active(true) do
        yield
      end
    end
  end
end
