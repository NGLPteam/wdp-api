# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        class FindOrigin
          include Dry::Monads[:result]

          # @param [HierarchicalEntity] entity
          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success(HierarchicalEntity)]
          # @return [Dry::Monads::Failure(:unknown_ancestor, Hash)]
          def call(entity, scope)
            return Success(entity) if entity.kind_of?(Community)

            case scope.origin
            when Schemas::Properties::References::Entities::Types::ANCESTOR
              extract_ancestor_from entity, name: Regexp.last_match[:ancestor_name]
            when "community"
              Success entity.community
            when "parent"
              Success entity.contextual_parent
            else
              # implicit `"self"`
              Success entity
            end
          end

          private

          def extract_ancestor_from(entity, name:)
            ancestor = entity.ancestor_by_name name

            return Success ancestor if ancestor

            Failure[:unknown_ancestor, { entity:, name: }]
          end
        end
      end
    end
  end
end
