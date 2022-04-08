# frozen_string_literal: true

module Searching
  class Origin
    include Dry::Initializer[undefined: false].define -> do
      param :model, Searching::Types::OriginModel, default: proc { :global }

      option :type, Searching::Types::OriginType, default: proc { model }
    end

    # @return [ActiveRecord::Relation<Entity>]
    def relation
      if entity?
        ::Entity.descending_from model
      elsif schema?
        model.entities.real
      else
        ::Entity.all
      end
    end

    # @!group Type Predicates

    def entity?
      type == :entity
    end

    def global?
      type == :global
    end

    def schema?
      type == :schema
    end

    # @!endgroup
  end
end
