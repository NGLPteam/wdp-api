# frozen_string_literal: true

module Testing
  module Merced
    # Read and parse the JSON for Merced units.
    #
    # @api private
    # @operation
    class ParseUnits
      include Dry::Monads[:try, :do, :result]
      prepend HushActiveRecord

      UNITS_PATH = Rails.root.join("vendor/ucm/ucm_units.json")

      TO_PRUNE = %i[widgets].freeze

      # These properties aren't required to visualize the hierarchy,
      # so we remove them from the output to make it clearer.
      TO_CLEAN = %i[
        about carousel contentCar1 contentCar2
        directSubmit directSubmitURL elements_id
        facebook hero logo nav_bar pages twitter
      ].freeze

      # @return [Dry::Monads::Success<ActiveSupport::HashWithIndifferentAccess>]
      def call(clean: false)
        parsed = yield parse

        pruned = prune! parsed

        return Success(pruned) unless clean

        cleaned = clean! pruned

        Success cleaned
      end

      private

      def parse
        Try do
          raw_content = UNITS_PATH.read

          parsed = JSON.parse raw_content

          { parsed: parsed }.with_indifferent_access.fetch :parsed
        end.to_result
      end

      def build_reparent_map(parsed)
        parsed.pluck(:id).uniq.index_with do |id|
          parsed.select { |parent| id.in? parent[:children] }.last&.[](:id)
        end.compact
      end

      def prune!(parsed)
        reparent_map = build_reparent_map parsed

        parsed.map do |unit|
          unit.without(*TO_PRUNE).merge(
            children: prune_children(unit, reparent_map)
          )
        end.uniq do |unit|
          unit[:id]
        end
      end

      def prune_children(unit, reparent_map)
        children = Array(unit[:children])

        children.select do |child_id|
          reparent_map[child_id] == unit[:id]
        end
      end

      def clean!(pruned)
        pruned.map do |unit|
          unit.without(*TO_CLEAN)
        end
      end
    end
  end
end
