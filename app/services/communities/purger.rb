# frozen_string_literal: true

module Communities
  # @see Communities::Purge
  class Purger < Support::HookBased::Actor
    include Entities::PurgeMethods
    include Dry::Initializer[undefined: false].define -> do
      param :community, Types::Community

      option :mode, Entities::Types::PurgeMode, default: proc { :purge }
    end

    standard_execution!

    # @return [ActiveRecord::Relation<Collection>]
    attr_reader :collections

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield purge_children!

        yield finalize!
      end

      Success()
    end

    wrapped_hook! def prepare
      @collections = community.collections.roots

      super
    end

    wrapped_hook! def purge_children
      collections.find_each do |collection|
        yield collection.purge(mode:)
      end

      super
    end

    wrapped_hook! def finalize
      yield finalize_for community

      super
    end
  end
end
