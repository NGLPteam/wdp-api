# frozen_string_literal: true

module Schemas
  module Associations
    # Given a list of associations, safely find all matching {SchemaVersion}s for them
    # and combine the results into an unordered array, with duplicates removed.
    #
    # @see Schemas::Associations::FindMatchingVersions
    class FindAllMatchingVersions
      include Dry::Monads[:result]
      include WDPAPI::Deps[find_matching_versions: "schemas.associations.find_matching_versions"]

      # @param [<Schemas::Associations::Association>] association
      # @return [Dry::Monads::Success<SchemaVersion>]
      def call(associations)
        versions = Types::Associations[associations].reduce [] do |acc, association|
          acc | find_matching_versions.call(association).value_or([])
        end

        Success versions
      end
    end
  end
end
