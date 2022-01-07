# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      # @abstract
      class Reader
        extend Dry::Initializer

        include Comparable

        def <=>(other)
          raise TypeError unless other.kind_of?(Schemas::Orderings::PathOptions::Reader)

          to_compare <=> other.to_compare
        end

        # @abstract
        # @!attribute [r] path
        # The actual path value to order by.
        # @return [String]
        def path
          nil
        end

        # @see Types::OrderingPathGroupingType
        # @return ["entity", "link", "props", "schema"]
        def grouping
          nil
        end

        def label_prefix
          nil
        end

        protected

        # @return [(String, String)]
        def to_compare
          [grouping, label]
        end
      end
    end
  end
end
