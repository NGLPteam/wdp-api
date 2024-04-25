# frozen_string_literal: true

module Schemas
  module Associations
    # @abstract
    class Association
      include StoreModel::Model
      include Schemas::Associations::Operations

      # @!attribute [rw] namespace
      # @return [String]
      attribute :namespace, :string

      # @!attribute [rw] identifier
      # @return [String]
      attribute :identifier, :string

      # @!attribute [rw] version
      # @return [Gem::Requirement]
      attribute :version, :version_requirement, default: proc { [] }

      delegate :satisfied_by?, to: :version, prefix: :version

      validates :namespace, :identifier, presence: true

      # @see Schemas::Associations::FindMatchingVersions
      # @return [<SchemaVersion>]
      def find_matching_versions
        find_matching_versions_for self
      end

      # @return [SchemaDefinition, nil]
      def find_schema_definition
        MeruAPI::Container["schemas.definitions.find"].(schema_definition_identifier).value_or(nil)
      end

      def has_version_requirement?
        !has_no_version_requirement?
      end

      def has_no_version_requirement?
        version.none?
      end

      # @see Schemas::Associations::Operations#require_matching_versions_for
      # @return [Dry::Monads::Success<SchemaVersion>]
      # @return [Dry::Monads::Failure(:no_match)]
      def require_matching_versions
        require_matching_versions_for self
      end

      # @!attribute [r] requirement
      # @return [String]
      def requirement
        "#{namespace}:#{identifier}#{version.for_lockfile}"
      end

      # @param [SchemaVersion] schema
      def satisfied_by?(schema)
        MeruAPI::Container["schemas.associations.satisfied_by"].call(self, schema).success?
      end

      # @!attribute [r] schema_definition_identifier
      # @return [String]
      def schema_definition_identifier
        "#{namespace}:#{identifier}"
      end
    end
  end
end
