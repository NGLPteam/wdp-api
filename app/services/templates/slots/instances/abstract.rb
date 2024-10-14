# frozen_string_literal: true

module Templates
  module Slots
    module Instances
      # @abstract
      class Abstract
        extend Dry::Core::ClassAttributes

        include Support::EnhancedStoreModel

        defines :kind, type: Templates::Types::SlotKind.optional

        kind "block"

        attribute :content, :string

        attribute :errors, :string_array

        attribute :valid, :boolean, default: false

        # @return [Templates::Types::SlotKind]
        def kind
          self.class.kind
        end

        class << self
          # @param [Templates::Types::SlotKind] kind
          # @return [Class]
          def klass_for(kind)
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
end
