# frozen_string_literal: true

module Types
  class AnyAssetType < Types::BaseUnion
    possible_types Types::AssetAudioType, Types::AssetDocumentType, Types::AssetImageType, Types::AssetPDFType, Types::AssetUnknownType, Types::AssetVideoType

    class << self
      def resolve_type(object, context)
        raise TypeError, "not an asset: #{object.inspect}" unless object.kind_of?(Asset)

        object.graphql_node_type
      end
    end
  end
end
