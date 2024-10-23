# frozen_string_literal: true

module Templates
  # The type registry used by {Template} and related records.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :enum_property_category, Templates::Types::EnumPropertyCategory
    tc.add! :enum_property_name, Templates::Types::EnumPropertyName
    tc.add! :layout_kind, Layouts::Types::Kind
    tc.add! :limit, Templates::Types::LimitWithFallback
    tc.add! :ordering_definition, Templates::Types::OrderingDefinition
    tc.add! :property_kind, Templates::Types::PropertyKind
    tc.add! :schema_component, Schemas::Types::Component
    tc.add! :selection_source, Templates::Types::SelectionSource
    tc.add! :slot_kind, Templates::Types::SlotKind
    tc.add! :stripped_string, Templates::Types::StrippedString
    tc.add! :template_kind, Templates::Types::Kind
    tc.add! :template_kinds, Templates::Types::Kinds
  end
end
