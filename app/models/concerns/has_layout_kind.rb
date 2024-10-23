# frozen_string_literal: true

module HasLayoutKind
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :layout_kind, type: ::Templates::Types::LayoutKind, coerce: ::Templates::Types::LayoutKind

    defines :layout_record, type: ::Templates::Types::LayoutRecord, coerce: ::Templates::Types::LayoutRecord

    pg_enum! :layout_kind, as: :layout_kind, allow_blank: false, suffix: :layout
  end

  # @return [::Layout]
  def layout_record
    self.class.layout_record
  end

  module ClassMethods
    def layout_kind!(new_value)
      layout_kind new_value

      layout_record layout_kind
    end
  end
end
