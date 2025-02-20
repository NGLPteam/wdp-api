# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class AncestorSchemaReader < Reader
        param :ancestor_name, Schemas::Orderings::Types::String

        param :property, Schemas::Orderings::Types.Instance(SchemaVersionProperty)

        priority 20

        delegate :label, :type, :schema_version, to: :property

        # @return ["props"]
        def grouping
          "ancestor_props"
        end

        def description
          property.metadata["description"]
        end

        def path
          "ancestors.#{ancestor_name}.props.#{property.path}##{type}"
        end

        def label_prefix
          "Ancestor (#{schema_version.name})"
        end
      end
    end
  end
end
