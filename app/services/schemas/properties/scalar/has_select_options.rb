# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module HasSelectOptions
        extend ActiveSupport::Concern

        included do
          attribute :options, SelectOption.to_array_type, default: proc { [] }
        end

        def option_values
          options.map(&:value)
        end

        def to_version_property_metadata
          super.tap do |h|
            h[:options] = options
          end
        end
      end
    end
  end
end
