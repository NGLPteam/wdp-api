# frozen_string_literal: true

module Items
  # @see Items::Purge
  class Purger < Support::HookBased::Actor
    include Entities::PurgeMethods
    include Dry::Initializer[undefined: false].define -> do
      param :item, Types::Item

      option :mode, Entities::Types::PurgeMode, default: proc { :purge }
    end

    standard_execution!

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
      @items = item.children

      super
    end

    wrapped_hook! def purge_children
      items.find_each do |item|
        yield item.purge(mode:)
      end

      super
    end

    wrapped_hook! def finalize
      yield finalize_for item

      super
    end
  end
end
