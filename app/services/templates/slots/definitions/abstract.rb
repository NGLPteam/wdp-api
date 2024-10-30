# frozen_string_literal: true

module Templates
  module Slots
    module Definitions
      class Abstract
        extend Dry::Core::ClassAttributes

        include Support::EnhancedStoreModel

        defines :kind, type: Templates::Types::SlotKind.optional

        kind "block"

        attribute :raw_template, :string

        # @return [Templates::Types::SlotKind]
        def kind
          self.class.kind
        end

        # @return [String, nil]
        def export_value
          raw_template
        end
      end
    end
  end
end
