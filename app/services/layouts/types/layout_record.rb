# frozen_string_literal: true

module Layouts
  module Types
    # @see ::Layout
    LayoutRecord = Instance(::Layout).constructor do |value|
      case value
      when ::Layout then value
      when ::Layouts::Types::Kind
        ::Layout.find(value.to_s)
      else
        raise Dry::Types::CoercionError.new("Invalid layout or layout_kind: #{value.inspect}")
      end
    end
  end
end
