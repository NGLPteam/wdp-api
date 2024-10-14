# frozen_string_literal: true

module Layouts
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Association = Coercible::Symbol

    Associations = Array.of(Association)

    Entity = Instance(::HierarchicalEntity)

    Generation = String.constrained(uuid_v4: true)

    Kind = ApplicationRecord.dry_pg_enum(:layout_kind)

    LayoutDefinition = Instance(::LayoutDefinition)

    LayoutInstance = Instance(::LayoutInstance)

    TemplateMapping = ApplicationRecord.pg_enum_values(:layout_kind).index_with do |layout_kind|
      ApplicationRecord.pg_enum_values(:"#{layout_kind}_template_kind")
    end.with_indifferent_access.freeze

    TemplateLookup = TemplateMapping.each_with_object({}) do |(layout, templates), lookup|
      templates.each do |template|
        # :nocov:
        raise "duplicate template #{template} for #{layout}, already in #{lookup[template]}" if template.in?(lookup)
        # :nocov:

        lookup[template] = layout
      end
    end.with_indifferent_access.freeze
  end
end
