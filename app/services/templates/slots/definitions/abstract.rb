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
      end
    end
  end
end
