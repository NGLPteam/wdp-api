# frozen_string_literal: true

module Entities
  class Error < Utility::IntuitiveError
    # @return [HierarchicalEntity]
    attr_reader :entity

    # @return [SchemaVersion]
    attr_reader :schema_version

    delegate :declaration, to: :schema_version

    message_key! :declaration

    # @param [HierarchicalEntity] entity
    def initialize(entity:, **)
      @entity = entity
      @schema_version = entity.schema_version

      super
    end
  end
end
