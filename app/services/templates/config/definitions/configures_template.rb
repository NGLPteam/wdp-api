# frozen_string_literal: true

module Templates
  module Config
    module Definitions
      # @api private
      module ConfiguresTemplate
        extend ActiveSupport::Concern

        include Templates::Config::Definitions::ConfiguresLayout

        included do
          extend Dry::Core::ClassAttributes

          defines :template_kind, type: ::Templates::Types::TemplateKind, coerce: ::Templates::Types::TemplateKind

          defines :template_record, type: ::Templates::Types::TemplateRecord, coerce: ::Templates::Types::TemplateRecord
        end

        # @!attribute [r] template_kind
        # @return [Templates::Types::TemplateKind]
        def template_kind
          self.class.template_kind
        end

        # @!attribute [r] template_record
        # @return [::Template]
        def template_record
          self.class.template_record
        end

        module ClassMethods
          # @param [Templates::Types::TemplateKind] kind
          # @return [void]
          def configures_template!(kind)
            template_kind kind
            template_record kind

            configures_layout! template_record.layout_kind
          end
        end
      end
    end
  end
end
