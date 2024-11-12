# frozen_string_literal: true

module Templates
  module Slots
    # @abstract
    class Abstract
      extend Dry::Core::ClassAttributes

      include Support::EnhancedStoreModel

      defines :kind, type: Templates::Types::SlotKind.optional

      kind "block"

      attribute :compiled, :boolean, default: false

      attribute :liquid_errors, Templates::Slots::Error.to_array_type

      # @return [Templates::Types::SlotKind]
      def kind
        self.class.kind
      end

      class << self
        # @param [Templates::Types::SlotKind] kind
        # @return [Class]
        def instance_klass_for(kind)
          case kind.to_s
          in "block"
            Templates::Slots::Instances::Block
          in "inline"
            Templates::Slots::Instances::Inline
          end
        end
      end
    end
  end
end
