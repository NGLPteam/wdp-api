# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      class Assigns < Abstract
        attribute :assignments, Harvesting::Extraction::Mappings::Assign, collection: true, default: -> { [] }

        xml do
          root "assigns"

          map_element "assign", to: :assignments
        end

        def each_shared_assignment
          # :nocov:
          return enum_for(__method__) unless block_given?
          # :nocov:

          assignments.each do |assignment|
            # :nocov:
            # Silently ignore reserved assignments
            next if assignment.reserved?
            # :nocov:

            yield assignment
          end
        end
      end
    end
  end
end
