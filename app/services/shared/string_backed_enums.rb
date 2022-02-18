# frozen_string_literal: true

module Shared
  module StringBackedEnums
    extend ActiveSupport::Concern

    class_methods do
      def string_enum(name, *values, **options)
        mapping = values.flatten.each_with_object({}) do |value, h|
          h[value.to_sym] = value.to_sym
        end

        enum(name, mapping, **options)
      end
    end
  end
end
