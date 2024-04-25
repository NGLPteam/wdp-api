# frozen_string_literal: true

module Harvesting
  module Contributions
    # A proxy object suitable for use with various harvesting subsystems
    # that represents both a {HarvestContribution} and a {HarvestContributor}.
    #
    # @see Harvesting::Contributions::Upsert
    # @see Harvesting::Contributors::Upsert
    class Proxy < ::Shared::FlexibleStruct
      include ::Shared::Typing

      attribute :kind, Harvesting::Types::String
      attribute? :metadata, Harvesting::Types::EmptyDefaultHash

      attribute :contributor do
        attribute :kind, ::Contributors::Types::Kind
        attribute :attributes, Harvesting::Types::EmptyDefaultHash
        attribute :properties, Harvesting::Types::EmptyDefaultHash

        # @return [(Symbol, Hash, Hash)]
        def to_upsert
          [kind, attributes, properties]
        end
      end

      # @return [Hash]
      def options
        { kind:, metadata: }
      end
    end
  end
end
