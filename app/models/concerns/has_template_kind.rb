# frozen_string_literal: true

module HasTemplateKind
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :template_kind, type: ::Templates::Types::Kind.optional

    pg_enum! :template_kind, as: :template_kind, allow_blank: false, suffix: :template
  end

  module ClassMethods
    def template_kind!(new_value)
      template_kind new_value
    end
  end
end
