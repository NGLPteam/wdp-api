# frozen_string_literal: true

module Schemas
  module Associations
    # Check if a given {Schemas::Associations::Abstract association} can be
    # satisfied by a {SchemaVersion}.
    class AnySatisfiedBy
      include WDPAPI::Deps[satisfied_by: "schemas.associations.satisfied_by"]

      # @param [<Schemas::Associations::Association>] association
      # @param [SchemaVersion] schema
      # @return [Dry::Monads::Result(Schemas::Associations::Validation::Result)]
      def call(associations, schema)
        Schemas::Associations::AnyAssociationSatisfier.new(associations, schema, satisfied_by).call
      end
    end
  end
end
