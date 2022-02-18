# frozen_string_literal: true

module Schemas
  module Associations
    # Given a list of associations, safely find all matching {SchemaVersion}s for them
    # and combine the results into an unordered array, with duplicates removed.
    #
    # @see Schemas::Associations::FindMatchingVersions
    class RequireAllMatchingVersions
      include Dry::Monads[:result, :list, :validated, :do]
      include WDPAPI::Deps[require_matching_versions: "schemas.associations.require_matching_versions"]

      # @param [<Schemas::Associations::Association>] associations
      # @return [Dry::Monads::Success<SchemaVersion>]
      def call(associations)
        attempts = Types::Associations[associations].map do |association|
          require_matching_versions.call(association).to_validated.or do
            Invalid(association)
          end
        end

        versions = yield check attempts

        Success versions
      end

      private

      # @return [Dry::Monads::Success<SchemaVersion>]
      # @return [Dry::Monads::Failure(:no_match, <Schemas::Associations::Association>)]
      def check(attempts)
        List::Validated.coerce(attempts).traverse.to_result.or do |missing|
          Failure[:no_match, missing.to_a]
        end.fmap do |versions|
          versions.to_a.reduce(&:|)
        end
      end
    end
  end
end
