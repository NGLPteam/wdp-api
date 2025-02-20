# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Builds an `ORDER BY` statement for fixed columns available on {OrderingEntryCandidate}.
      #
      # @api private
      class ByColumns < Base
        option :columns, Schemas::Orderings::Types::ColumnList

        def attributes_for(...)
          source_table = ancestor? ? ancestor_alias : arel_table

          columns.map do |column|
            source_table[column]
          end
        end
      end
    end
  end
end
