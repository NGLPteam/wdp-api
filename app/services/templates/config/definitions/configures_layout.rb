# frozen_string_literal: true

module Templates
  module Config
    module Definitions
      # @api private
      module ConfiguresLayout
        extend ActiveSupport::Concern

        included do
          extend Dry::Core::ClassAttributes

          defines :layout_kind, type: ::Templates::Types::LayoutKind, coerce: ::Templates::Types::LayoutKind

          defines :layout_record, type: ::Templates::Types::LayoutRecord, coerce: ::Templates::Types::LayoutRecord
        end

        # @!attribute [r] layout_kind
        # @return [Templates::Types::Layout]
        def layout_kind
          self.class.layout_kind
        end

        # @!attribute [r] layout_record
        # @return [::Layout]
        def layout_record
          self.class.layout_record
        end

        module ClassMethods
          # @param [Templates::Types::LayoutKind] kind
          # @return [void]
          def configures_layout!(kind)
            layout_kind kind
            layout_record kind
          end
        end
      end
    end
  end
end
