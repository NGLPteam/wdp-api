# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module ValidatesSize
        extend ActiveSupport::Concern

        included do
          attribute :min_size, :integer
          attribute :max_size, :integer
        end

        def base_schema_predicates
          super().merge(size_schema_predicates)
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
