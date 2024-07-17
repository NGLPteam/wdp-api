# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add_model! "Collection"
    tc.add_model! "Community"
    tc.add_model! "ControlledVocabulary"
    tc.add_model! "ControlledVocabularySource"
    tc.add_model! "Item"
    tc.add_model! "SchemaDefinition"
    tc.add_model! "SchemaVersion"
  end
end
