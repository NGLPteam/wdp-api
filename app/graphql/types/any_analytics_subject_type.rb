# frozen_string_literal: true

module Types
  class AnyAnalyticsSubjectType < Types::BaseUnion
    description <<~TEXT
    Presently this is just assets, but may be other types in the future.
    TEXT

    possible_types Types::AssetAudioType, Types::AssetDocumentType, Types::AssetImageType, Types::AssetPDFType, Types::AssetUnknownType, Types::AssetVideoType

    class << self
      def resolve_type(object, context)
        raise TypeError, "not an asset: #{object.inspect}" unless object.kind_of?(Asset)

        object.graphql_node_type
      end
    end
  end
end
