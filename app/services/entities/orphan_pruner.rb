# frozen_string_literal: true

module Entities
  # Prune (unharvested by default) entities from within an optional root `source` entity,
  # based on a certain schema.
  #
  # This service is intended to prune errant or misidentified entities from the harvesting
  # process after it has been refined in a later pass.
  class OrphanPruner
    include Dry::Monads[:result]
    include Dry::Initializer[undefined: false].define -> do
      option :unharvested, ::Entities::Types::Bool, default: proc { true }
      option :schema, ::Entities::Types::String
      option :source, ::Entities::Types::Entity.optional, optional: true
    end

    # @return [Dry::Monads::Success(Integer)]
    def call
      query = base_scope

      count = 0

      query.find_each do |reference|
        destroy! reference

        count += 1
      end

      Success count
    end

    private

    # @return [ActiveRecord::Relation]
    def base_scope
      if source.present?
        source.entity_descendants.sans_links.preload(:descendant)
      else
        Entity.real.preload(:hierarchical)
      end.then do |scope|
        scope.filtered_by_schema_version(schema)
      end.then do |scope|
        unharvested ? scope.unharvested : scope.all
      end
    end

    # @param [EntityDescendant, Entity] reference
    # @return [void]
    def destroy!(reference)
      if source.present?
        reference.descendant.destroy
      else
        reference.hierarchical.destroy
      end
    end
  end
end
