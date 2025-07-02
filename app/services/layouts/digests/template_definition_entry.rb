# frozen_string_literal: true

module Layouts
  module Digests
    class TemplateDefinitionEntry
      include Support::EnhancedStoreModel

      attribute :template_definition_type, :string
      attribute :template_definition_id, :string
      attribute :template_kind, :string
      attribute :position, :integer
    end
  end
end
