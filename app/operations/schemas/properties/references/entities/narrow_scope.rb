# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        # Once an origin has been established, we gotta build a scope based on the
        # target type.
        class NarrowScope
          include Dry::Monads[:result, :do]
          include WDPAPI::Deps[
            find_schemas: "schemas.properties.references.entities.find_schemas",
          ]

          # @param [HierarchicalEntity] actual
          # @param [HierarchicalEntity] origin
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation)]
          def call(actual, origin, scope)
            if scope.targets_links?
              link_scope_for actual, origin, scope
            elsif scope.targets_siblings?
              # We ignore the origin for an a sibling scope
              sibling_scope_for actual, scope
            elsif scope.targets_any?
              # We ignore the origin for an any scope
              any_scope_for actual, scope
            else
              descendant_scope_for actual, origin, scope
            end
          end

          private

          # @param [HierarchicalEntity] actual
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @param [HierarchicalEntity, nil] origin
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def initial_scope_for(actual, scope, origin: nil)
            hierarchicals = [actual, origin].compact.uniq

            query = ::Entity.actual.preload(:hierarchical).except_hierarchical(hierarchicals)

            apply_schema_versions_to query, scope
          end

          # @param [ActiveRecord::Relation<::Entity>] relation
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def apply_schema_versions_to(relation, scope)
            versions = yield find_schemas.call(scope)

            return Success relation if versions.blank?

            Success relation.where(schema_version: versions)
          end

          # @param [HierarchicalEntity] entity
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def any_scope_for(entity, scope)
            initial_scope_for(entity, scope)
          end

          # @param [HierarchicalEntity] actual
          # @param [HierarchicalEntity] origin
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def descendant_scope_for(actual, origin, scope)
            query = yield initial_scope_for actual, scope, origin: origin

            Success query.descendants_of(origin, depth: scope.depth)
          end

          # @param [HierarchicalEntity] actual
          # @param [HierarchicalEntity] origin
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def link_scope_for(actual, origin, scope)
            query = yield initial_scope_for actual, scope, origin: origin

            Success query.links_for(origin, direction: scope.direction)
          end

          # @param [HierarchicalEntity] entity
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(ActiveRecord::Relation<::Entity>)]
          def sibling_scope_for(entity, scope)
            query = yield initial_scope_for(entity, scope)

            Success query.siblings_of(entity)
          end
        end
      end
    end
  end
end
