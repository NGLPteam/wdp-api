# frozen_string_literal: true

module Collections
  # @see Collections::Purge
  class Purger < Support::HookBased::Actor
    include Entities::PurgeMethods
    include Dry::Initializer[undefined: false].define -> do
      param :collection, Types::Collection

      option :mode, Entities::Types::PurgeMode, default: proc { :purge }
    end

    standard_execution!

    # @return [ActiveRecord::Relation<Collection>]
    attr_reader :collections

    # @return [ActiveRecord::Relation<Item>]
    attr_reader :items

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
      @collections = collection.children

      @items = collection.items.roots

      super
    end

    wrapped_hook! def purge_children
      collections.find_each do |collection|
        yield collection.purge(mode:)
      end

      items.find_each do |item|
        yield item.purge(mode:)
      end

      super
    end

    wrapped_hook! def finalize
      yield finalize_for collection

      super
    end
  end
end
