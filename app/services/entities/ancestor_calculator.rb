# frozen_string_literal: true

module Entities
  class AncestorCalculator
    include Dry::Initializer[undefined: false].define -> do
      param :descendant, AppTypes.Instance(::SyncsEntities)
    end

    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      calculate_ancestors: "entities.calculate_ancestors"
    ]

    # @return [Dry::Monads::Success<SyncsEntities>]
    def call
      @set = Set.new

      @set.merge yield ancestors_for(descendant)

      @set << descendant

      Success @set.to_a
    end

    private

    def ancestors_for(value)
      case value
      when Community
        Success([value])
      when ChildEntity
        calculate_ancestors.(value.contextual_parent)
      when EntityLink
        calculate_ancestors.(value.source)
      else
        # :nocov:
        Failure[:unknown_entity, value]
        # :nocov:
      end
    end
  end
end
