# frozen_string_literal: true

module Templates
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Assigns = Hash.map(Coercible::String, Any)

    Entity = Instance(::HierarchicalEntity)

    ErrorMode = Coercible::Symbol.default(:strict).enum(:strict, :warn, :lax).fallback(:strict)

    Generation = String.constrained(uuid_v4: true)

    Kind = TemplateKind = ApplicationRecord.dry_pg_enum(:template_kind)

    Kinds = Array.of(Kind)

    LayoutDefinition = Instance(::LayoutDefinition)

    LayoutInstance = Instance(::LayoutInstance)

    LayoutKind = ApplicationRecord.dry_pg_enum(:layout_kind)

    SlotKind = ::Types::TemplateSlotKindType.dry_type

    StrippedString = Coercible::String.constructor { _1.to_s.strip_heredoc.strip }

    TemplateDefinition = Instance(::TemplateDefinition)

    TemplateInstance = Instance(::TemplateInstance)
  end
end
