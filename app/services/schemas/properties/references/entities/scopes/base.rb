# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        module Scopes
          # @abstract
          class Base
            extend Dry::Core::ClassAttributes

            include StoreModel::Model
            include ::Schemas::Associations::Operations
            include ::Shared::StringBackedEnums
            include OriginPredicates

            # @!scope class
            # @!attribute [r] schemas_required
            # @return [Boolean]
            defines :schemas_required, type: Dry::Types["bool"]

            schemas_required false

            attribute :schemas, Schemas::Associations::EntityScope.to_array_type, default: proc { [] }

            string_enum :target, :any, :descendants, :links, :siblings,
              default: :descendants,
              _prefix: :targets

            delegate :schemas_required?, to: :schemas_required

            validates :schemas, store_model: true, length: { minimum: 1, if: :schemas_required? }

            def detected_versions
              find_all_matching_versions_for schemas
            end

            def matching_versions
              require_all_matching_versions_for schemas
            end

            class << self
              alias schemas_required? schemas_required
            end
          end
        end
      end
    end
  end
end
