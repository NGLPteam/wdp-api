# frozen_string_literal: true

module HasLayoutKind
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :layout_kind, type: ::Layouts::Types::Kind.optional

    pg_enum! :layout_kind, as: :layout_kind, allow_blank: false, suffix: :layout
  end

  module ClassMethods
    def layout_kind!(new_value)
      layout_kind new_value
    end
  end
end
