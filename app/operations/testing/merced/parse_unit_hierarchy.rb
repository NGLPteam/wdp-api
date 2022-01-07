# frozen_string_literal: true

module Testing
  module Merced
    # Reorganize the units JSON into the structure it will wind up
    # in when imported via {Testing::Merced::Import}.
    #
    # @api private
    # @operation
    class ParseUnitHierarchy
      include Dry::Monads[:result, :do]

      include WDPAPI::Deps[
        parse_units: "testing.merced.parse_units",
      ]

      prepend HushActiveRecord

      def call
        units = yield parse_units.call clean: true

        id_report = make_id_report units

        @count = 0

        hierarchy = units.each_with_object([]) do |unit, hier|
          next unless unit[:type] == "campus"

          recursed = recurse unit, units

          hier << recursed
        end

        result = {
          id_report: id_report,
          unit_count: units.size,
          hierarchy_count: @count,
          hierarchy: hierarchy,
        }

        Success result
      ensure
        @count = 0
      end

      private

      def make_id_report(units)
        parent_counts = units.pluck(:id).tally

        ids = parent_counts.keys

        stats = ids.index_with do |id|
          {}.tap do |x|
            x[:parents] = units.select { |u| id.in? u[:children] }.pluck(:id)
            x[:occurrences] = parent_counts.fetch id
          end
        end

        {
          id_count: ids.size,
          unit_count: units.size,
          stats: stats,
        }
      end

      def recurse(unit, units)
        children = Array(unit[:children]).map do |child_id|
          child = units.detect { |u| u[:id] == child_id }

          next nil if child.blank?

          recurse(child, units)
        end.compact.presence

        unit[:children] = children

        unit.compact!

        @count += 1

        return unit
      end
    end
  end
end
