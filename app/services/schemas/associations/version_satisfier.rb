# frozen_string_literal: true

module Schemas
  module Associations
    # @api private
    # @see Schemas::Associations::SatisfiedBy
    class VersionSatisfier
      include Dry::Monads[:result]
      include Dry::Initializer[undefined: false].define -> do
        param :association, Types::Association
        param :schema, Types::Schema
      end

      delegate :namespace, :identifier, :version, to: :association, prefix: :required
      delegate :namespace, :identifier, :declaration, to: :schema, prefix: :provided
      delegate :has_no_version_requirement?, :requirement, to: :association

      # @return [Dry::Monads::Success(String)] a monad including the successfully-met requirement
      # @return [Dry::Monads::Failure(:invalid_namespace, String, String)]
      # @return [Dry::Monads::Failure(:invalid_identifier, String, String)]
      # @return [Dry::Monads::Failure(:invalid_version, String, String)]
      def call
        return failure_for(:invalid_namespace) unless required_namespace == provided_namespace
        return failure_for(:invalid_identifier) unless required_identifier == provided_identifier

        unless association.has_no_version_requirement?
          return failure_for(:invalid_version) unless required_version.satisfied_by? schema.gem_version
        end

        return Success requirement
      end

      private

      def failure_for(key)
        message = "Requires #{requirement}, received #{provided_declaration}"

        Failure[key, message]
      end
    end
  end
end
