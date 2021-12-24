# frozen_string_literal: true

module MutationOperations
  # @abstract
  class Contract < ApplicationContract
    include Dry::Effects.Resolve(:current_user)
    include Dry::Effects.Resolve(:local_context)
    include WDPAPI::Deps[
      validate_association: "schemas.associations.polymorphic.validate_association",
    ]

    DEFAULT_EDGE = :edge

    # @return [{ Symbol => Schemas::Edges::Edge, nil }]
    def derived_edges
      local_context[:edges]
    end

    # Retrieve the default edge that was loaded previously
    # @return [Schemas::Edges::Edge, nil]
    def default_edge
      local_context[:edges][DEFAULT_EDGE]
    end

    def has_default_edge?
      has_edge? DEFAULT_EDGE
    end

    def has_edge?(key)
      derived_edges[key].kind_of?(Schemas::Edges::Edge)
    end

    def has_loaded_schema_version?
      loaded_schema_version.present?
    end

    def loaded_schema_version
      local_context[:schema_version]
    end

    class << self
      def validate_association_between!(parent, child)
        rule(parent, child) do
          validate_association.call(values[parent], values[child]) do |m|
            m.valid do |_|
              # we're okay
            end

            m.mutually_invalid do |err|
              key(parent).failure(:invalid_schema_child, declaration: err.child.provided_declaration)
              key(child).failure(:invalid_schema_parent, declaration: err.parent.provided_declaration)
            end

            m.invalid_child do |err|
              key(parent).failure(:invalid_schema_child, declaration: err.provided_declaration)
            end

            m.invalid_parent do |err|
              key(child).failure(:invalid_schema_parent, declaration: err.provided_declaration)
            end
          end
        end
      end

      def validate_association_between_parent_and_schema_version!(parent_key: :parent, schema_key: :schema_version_slug)
        rule(parent_key, schema_key) do
          parent_value = values[parent_key]
          child_value = loaded_schema_version

          validate_association.call(parent_value, child_value) do |m|
            m.valid do |_|
              # we're okay
            end

            m.mutually_invalid do |err|
              key(parent_key).failure(:invalid_schema_child, declaration: err.child.provided_declaration)
              key(schema_key).failure(:invalid_parent_for_schema, declaration: err.parent.provided_declaration)
            end

            m.invalid_child do |err|
              key(parent_key).failure(:invalid_schema_child, declaration: err.provided_declaration)
            end

            m.invalid_parent do |err|
              key(schema_key).failure(:invalid_parent_for_schema, declaration: err.provided_declaration)
            end
          end if has_loaded_schema_version?
        end
      end

      # Validate cases where we are assigning a new schema to an entity, and we need to check if the parent is okay.
      #
      # @todo Checking children will be automated later.
      #
      # @see Mutations::Contracts::AlterSchemaVersion
      def validate_association_between_contextual_parent_and_new_schema_version!(child_key: :entity, schema_key: :schema_version_slug)
        rule(child_key, schema_key) do
          parent_value = values[child_key].contextual_parent
          child_value = loaded_schema_version

          validate_association.call(parent_value, child_value) do |m|
            m.valid do |_|
              # we're okay
            end

            m.mutually_invalid do |err|
              key(child_key).failure(:invalid_new_schema_for_parent, declaration: err.child.provided_declaration)
              key(schema_key).failure(:invalid_parent_for_schema, declaration: err.parent.provided_declaration)
            end

            m.invalid_child do |err|
              key(child_key).failure(:invalid_new_schema_for_parent, declaration: err.provided_declaration)
            end

            m.invalid_parent do |err|
              key(schema_key).failure(:invalid_parent_for_schema, declaration: err.provided_declaration)
            end
          end if has_loaded_schema_version?
        end
      end
    end
  end
end
