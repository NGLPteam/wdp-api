# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Float < Base
        attribute :gt, :decimal
        attribute :gte, :decimal
        attribute :lt, :decimal
        attribute :lte, :decimal
        attribute :default, :decimal

        schema_type! :decimal

        def build_schema_predicates
          super.merge(
            gteq?: gte,
            gt?: gt,
            lt?: lt,
            lteq?: lte
          ).compact
        end
      end
    end
  end
end
