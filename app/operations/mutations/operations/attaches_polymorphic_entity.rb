# frozen_string_literal: true

module Mutations
  module Operations
    module AttachesPolymorphicEntity
      extend ActiveSupport::Concern

      # @param [HasSchemaDefinition] entity
      # @return [void]
      def attach_polymorphic_entity!(entity)
        attach! :entity, entity

        specified_kind = entity.model_name.singular.to_sym

        attach! specified_kind, entity

        Success entity
      end
    end
  end
end
