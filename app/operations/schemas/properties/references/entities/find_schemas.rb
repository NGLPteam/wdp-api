# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        # Find a set of schemas for the given scope.
        class FindSchemas
          include Dry::Monads[:result, :do]
          include WDPAPI::Deps[
            require_all_matching_versions: "schemas.associations.require_all_matching_versions"
          ]

          # @param [Schemas::Properties::References::Entities::Scopes::Base] scope
          # @return [Dry::Monads::Success<SchemaVersion>]
          def call(scope)
            schemas = scope.schemas

            return Failure[:no_schemas] if schemas.blank? && scope.schemas_required?

            require_all_matching_versions.call schemas
          end
        end
      end
    end
  end
end
