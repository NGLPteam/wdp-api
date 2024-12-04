# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :any_entity, Entities::Types::Entity

    tc.add_model! "Collection"
    tc.add_model! "Community"
    tc.add_model! "ControlledVocabulary"
    tc.add_model! "ControlledVocabularySource"
    tc.add_model! "Item"
    tc.add_model! "SchemaDefinition"
    tc.add_model! "SchemaVersion"

    tc.add_enum! ::Types::TemplateSlotKindType, single_key: "slot_kind", plural_key: "slot_kinds"
  end
end
