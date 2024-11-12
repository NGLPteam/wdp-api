# frozen_string_literal: true

module Templates
  class AssignsBuilder < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :entity, Entities::Types::Entity.optional, optional: true
    end

    standard_execution!

    # @return [{ String => Object }]
    attr_reader :assigns

    # @return [Dry::Monads::Success({ String => Object })]
    def call
      run_callbacks :execute do
        yield prepare!

        yield extract_entity!
      end

      Success assigns.stringify_keys
    end

    wrapped_hook! def prepare
      @assigns = {}.with_indifferent_access

      super
    end

    wrapped_hook! def extract_entity
      return super unless entity.present?

      drop = entity.to_liquid

      ancestors = Templates::Drops::AncestorsDrop.new(entity)

      community = entity.community.to_liquid

      assigns[:self] = assigns[:entity] = drop

      assigns[:ancestors] = ancestors
      assigns[:community] = community
      assigns[:props] = drop.props
      assigns[:schema] = drop.schema

      super
    end
  end
end
