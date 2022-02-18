# frozen_string_literal: true

module Schemas
  module Properties
    module References
      # Shared logic for referencing a {HierarchicalEntity}.
      module Entity
        extend ActiveSupport::Concern

        include Schemas::Properties::References::Model

        included do
          include WDPAPI::Deps[
            available_entity_scope: "schemas.properties.references.entities.find_available"
          ]

          model_types! ::Community, ::Collection, ::Item

          attribute :scope, Schemas::Properties::References::Entities::Scope.to_type, default: proc { { target: "descendants" } }
        end

        # @see Schemas::Properties::References::Entities::FindAvailable
        # @param [HierarchicalEntity, nil] entity
        # @return [Dry::Monads::Result]
        def available_entities_for(entity)
          available_entity_scope.call(entity, scope)
        end

        def add_to_rules!(context)
          super

          if collected_reference?
            context.rule(path).each(scopes_entity: self)
          else
            context.rule(path).validate(scopes_entity: self)
          end
        end
      end
    end
  end
end
