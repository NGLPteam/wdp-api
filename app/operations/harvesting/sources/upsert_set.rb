# frozen_string_literal: true

module Harvesting
  module Sources
    # Some sources do not behave properly and don't enumerate their sets. We need
    # a way to define a {HarvestSet} directly in this case.
    class UpsertSet
      include Dry::Monads[:result]

      # @param [HarvestSource] source
      # @param [String] identifier
      # @return [Dry::Monads::Result]
      def call(source, identifier)
        set = source.harvest_sets.by_identifier(identifier).first_or_initialize do |new_set|
          new_set.name = identifier
          new_set.metadata ||= {}
          new_set.metadata["added_missing"] = true
        end

        set.save!

        Success set
      end
    end
  end
end
