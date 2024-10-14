# frozen_string_literal: true

module Templates
  # The type registry used by {Template} and related records.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :layout_kind, Layouts::Types::Kind
    tc.add! :template_kind, Templates::Types::Kind
    tc.add! :template_kinds, Templates::Types::Kinds
    tc.add! :slot_kind, Templates::Types::SlotKind
    tc.add! :stripped_string, Templates::Types::StrippedString
  end
end
