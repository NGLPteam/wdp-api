# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class SchemaReader < Reader
        param :property, Schemas::Orderings::Types.Instance(SchemaVersionProperty)

        delegate :label, :type, :schema_version, to: :property

        # @return ["props"]
        def grouping
          "props"
        end

        def description
          property.metadata["description"]
        end

        def path
          "props.#{property.path}"
        end

        def label_prefix
          property.schema_version.name
        end
      end
    end
  end
end
