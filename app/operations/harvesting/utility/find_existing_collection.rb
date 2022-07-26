# frozen_string_literal: true

module Harvesting
  module Utility
    # Find an existing collection by identifier based on mapping options.
    #
    # Setting {Harvesting::Options::Mapping#link_identifiers_globally} will
    # search across the _entire_ hierarchy, and requires that an installation
    # is using identifiers uniquely. Since this is not enforced, it's possible
    # that trying to find a collection could raise {LimitToOne::TooManyMatches}
    # at runtime, and therefore requires opting in.
    class FindExistingCollection
      include Dry::Effects.Resolve(:link_identifiers_globally)
      include Dry::Effects.Resolve(:target_entity)

      include WDPAPI::Deps[find_global_collections: "entities.find_global_collections"]

      # @param [String, nil] identifier
      # @raise [ActiveRecord::RecordNotFound]
      # @raise [LimitToOne::TooManyMatches]
      # @return [Collection, nil]
      def call(identifier)
        return nil if identifier.blank?

        if link_identifiers_globally
          find_global_collections.(target_entity).by_identifier(identifier).only_one!
        else
          target_entity.descendant_collection_by! identifier
        end
      end
    end
  end
end
