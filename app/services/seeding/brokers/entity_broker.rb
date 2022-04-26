# frozen_string_literal: true

module Seeding
  module Brokers
    module EntityBroker
      extend ActiveSupport::Concern

      included do
        defines :model_klass, type: Seeding::Types::EntityClass.optional

        attribute :schemas, Seeding::Brokers::SchemasBroker

        delegate :broker_for, to: :schemas, prefix: :schema
      end

      # @param [HierarchicalEntity] entity
      def supported?(entity)
        entity.kind_of?(self.class.model_klass) && schemas.supported?(entity.schema_version)
      end
    end
  end
end
