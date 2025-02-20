# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class AncestorStaticReader < Reader
        param :ancestor_name, Schemas::Orderings::Types::String

        param :property, Schemas::Orderings::Types.Instance(StaticAncestorOrderableProperty)

        param :schema_version, Schemas::Types::Version

        priority 10

        delegate :grouping, :label, :description, :type, to: :property

        def label_prefix
          "Ancestor (#{schema_version.name})"
        end

        def path
          property.path_for(ancestor_name)
        end
      end
    end
  end
end
