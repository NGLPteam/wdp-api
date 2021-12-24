# frozen_string_literal: true

module Schemas
  module Associations
    # Check if a given {Schemas::Associations::Abstract association} can be
    # satisfied by a {SchemaVersion}.
    class SatisfiedBy
      include Dry::Monads[:do, :result]

      # @param [Schemas::Associations::Association] association
      # @param [SchemaVersion] schema
      # @return [Dry::Monads::Result]
      def call(association, schema)
        Schemas::Associations::VersionSatisfier.new(association, schema).call
      end
    end
  end
end
