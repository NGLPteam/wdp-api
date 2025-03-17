# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module ValidatesSize
        extend ActiveSupport::Concern

        include ValidatesSizeSanity

        included do
          attribute :min_size, :integer, default: proc { 0 }
          attribute :max_size, :integer

          validates :min_size, numericality: { allow_nil: true, integer_only: true, greater_than_or_equal_to: 0 }
          validates :max_size, numericality: { allow_nil: true, integer_only: true, greater_than: 1 }
        end

        def base_schema_predicates
          super.merge(size_schema_predicates)
        end

        def size_schema_predicates
          {
            min_size?: min_size,
            max_size?: max_size
          }.compact
        end
      end
    end
  end
end
