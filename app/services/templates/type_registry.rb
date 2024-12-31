# frozen_string_literal: true

module Templates
  # The type registry used by {Template} and related records.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :contributor_list_filter, Templates::Types::ContributorListFilter
    tc.add! :entity, Templates::Types::Entity
    tc.add! :entities, Templates::Types::Entities
    tc.add! :enum_property_category, Templates::Types::EnumPropertyCategory
    tc.add! :enum_property_name, Templates::Types::EnumPropertyName
    tc.add! :layout_kind, Layouts::Types::Kind
    tc.add! :limit, Templates::Types::LimitWithFallback
    tc.add! :ordering_definition, Templates::Types::OrderingDefinition
    tc.add! :property_kind, Templates::Types::PropertyKind
    tc.add! :property_name, Templates::Types::PropertyName
    tc.add! :schema_component, Schemas::Types::Component
    tc.add! :schema_property_path, Schemas::Properties::Types::FullPath
    tc.add! :selection_source, Templates::Types::SelectionSource
    tc.add! :slot_kind, Templates::Types::SlotKind
    tc.add! :stripped_string, Templates::Types::StrippedString
    tc.add! :template_kind, Templates::Types::Kind
    tc.add! :template_kinds, Templates::Types::Kinds
    tc.add! :template_width, Templates::Types::TemplateWidth
    tc.add! :uploaded_file, Templates::Types.Instance(ActionDispatch::Http::UploadedFile)
  end
end
