# frozen_string_literal: true

module ContributionRoles
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Contributable = ModelInstance("Collection") | ModelInstance("Item")

    Role = ModelInstance("ControlledVocabularyItem")
  end
end
