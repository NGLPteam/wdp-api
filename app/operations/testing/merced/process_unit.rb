# frozen_string_literal: true

module Testing
  module Merced
    # Process a unit JSON and recursively upsert
    # its children before yielding back to {Testing::Merced::ProcessUnits}.
    #
    # @api private
    # @operation
    class ProcessUnit
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:units)
      include Dry::Effects.State(:unit_ids)
      include WDPAPI::Deps[
        upsert_page: "testing.merced.upsert_page",
        upsert_unit: "testing.merced.upsert_unit",
      ]
      prepend HushActiveRecord

      # @param [ActiveSupport::HashWithIndifferentAccess] unit_definition
      # @return [Dry::Monads::Result]
      def call(unit_definition, parent: nil)
        unit = yield upsert_unit.call unit_definition, parent: parent

        unit_definition[:pages].each_with_index do |page, index|
          yield upsert_page.call page, index: index, parent: unit
        end

        Array(unit_definition[:children]).uniq.each do |child_id|
          child = units.detect { |c| c[:id] == child_id }

          yield call child, parent: unit if child.present?
        end

        Success unit
      end
    end
  end
end
