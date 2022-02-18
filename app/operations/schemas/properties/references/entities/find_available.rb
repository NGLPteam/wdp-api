# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        class FindAvailable
          include Dry::Monads[:result]
          include WDPAPI::Deps[
            find_origin: "schemas.properties.references.entities.find_origin",
            narrow_scope: "schemas.properties.references.entities.narrow_scope",
          ]

          # @param [HierarchicalEntity] entity
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [ActiveRecord::Relation<Entity>]
          # @return [ActiveRecord::Relation<HierarchicalEntity>]
          def call(entity, scope)
            return Success [] if entity.blank?

            result = find_origin.call(entity, scope).bind do |origin|
              narrow_scope.call(entity, origin, scope)
            end

            result.or do
              # We fall back to a null relation

              Success ::Entity.none
            end
          end
        end
      end
    end
  end
end
