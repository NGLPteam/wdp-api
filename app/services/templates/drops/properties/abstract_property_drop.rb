# frozen_string_literal: true

module Templates
  module Drops
    module Properties
      # @abstract
      class AbstractPropertyDrop < Templates::Drops::AbstractDrop
        # @param [HierarchicalEntity] entity
        # @param [Schemas::Properties::GroupReader, Schemas::Properties::Reader] reader
        def initialize(entity, reader)
          super

          @entity = entity

          @reader = reader
        end

        def to_s
          value.to_s
        end

        def value
          @reader.value
        end

        private

        def group?
          @reader.group?
        end
      end
    end
  end
end
