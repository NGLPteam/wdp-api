# frozen_string_literal: true

module Layouts
  module Types
    # @see ::Layouts::Types::LayoutRecord
    LayoutRecords = Coercible::Array.of(::Layouts::Types::LayoutRecord)
  end
end
