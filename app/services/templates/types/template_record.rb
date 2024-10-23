# frozen_string_literal: true

module Templates
  module Types
    # @see ::Template
    TemplateRecord = Instance(::Template).constructor do |value|
      case value
      when ::Template then value
      when Templates::Types::TemplateKind
        ::Template.find(value.to_s)
      else
        raise Dry::Types::CoercionError.new("Invalid template or template_kind: #{value.inspect}")
      end
    end
  end
end
