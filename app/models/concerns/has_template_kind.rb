# frozen_string_literal: true

module HasTemplateKind
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :template_kind, type: ::Templates::Types::TemplateKind, coerce: ::Templates::Types::TemplateKind

    defines :template_record, type: ::Templates::Types::TemplateRecord, coerce: ::Templates::Types::TemplateRecord

    pg_enum! :template_kind, as: :template_kind, allow_blank: false, suffix: :template
  end

  # @return [::Template]
  def template_record
    self.class.template_record
  end

  module ClassMethods
    def template_kind!(new_value)
      template_kind new_value

      template_record template_kind
    end
  end
end
