# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Builds an `ORDER BY` statement for variable date columns available on {OrderingEntryCandidate}.
      #
      # @api private
      class ByVariableDate < Base
        option :path, NamedVariableDates::Types::GlobalPath

        def attributes_for(*)
          nvd = join_for_variable_date path

          [
            nvd[:value],
            nvd[:precision]
          ]
        end
      end
    end
  end
end
