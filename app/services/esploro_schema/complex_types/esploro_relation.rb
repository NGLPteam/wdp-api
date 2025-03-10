# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRelation
    class EsploroRelation < EsploroSchema::Common::AbstractComplexType
      # Is this relation to an asset in the repository (internal) or to an external asset?
      # Valid values are "EXTERNAL" or "INTERNAL".
      # Mandatory for asset to asset relations.
      property! :category, EsploroSchema::SimpleTypes::EsploroAssetToAssetRelationshipType

      # Type of relation to a different asset.
      # Use value from RelationType.
      # Mandatory for asset to asset relations.
      property! :type, EsploroSchema::SimpleTypes::RelationType

      # List of identifiers related to the asset.
      # Relevant to internal relations only.
      property! :related_identifiers, EsploroSchema::Wrappers::RelatedIdentifiers, collection: true

      # Title of the related external asset. Free-text.
      # Mandatory for external relations.
      # Not relevant for internal relations.
      property! :related_title, :string

      # DOI of the related external asset. Free-text.
      # Not mandatory for external relations.
      # Not relevant for internal relations.
      property! :related_doi, :string

      # URL of the related external asset.
      # Mandatory for external relations.
      # Not relevant for internal relations.
      # When using a DOI, make sure to insert a full URL and not only the DOI number.
      property! :related_url, :string

      xml do
        root "relation", mixed: true

        map_element "relation.category", to: :category
        map_element "relationType", to: :type
        map_element "relatedIdentifiers", to: :wrapped_related_identifiers
        map_element "relatedTitle", to: :related_title
        map_element "relatedDoi", to: :related_doi
        map_element "relatedUrl", to: :related_url
      end
    end
  end
end
