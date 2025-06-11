# frozen_string_literal: true

module Entities
  # @see Entities::Purge
  class Purger < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :entity, Entities::Types::Entity

      option :mode, Entities::Types::PurgeMode, default: proc { :purge }
    end

    standard_execution!

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield purge!
      end

      Success()
    end

    wrapped_hook! def purge
      yield entity.purge(mode:)

      super
    end
  end
end
