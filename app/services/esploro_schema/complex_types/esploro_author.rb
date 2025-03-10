# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @abstract
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroAuthor
    # @see EsploroSchema::ComplexTypes::EsploroCreator
    # @see EsploroSchema::ComplexTypes::EsploroContributor
    class EsploroAuthor < EsploroSchema::Common::AbstractComplexType
      property! :family_name, :string

      property! :given_name, :string

      property! :middle_name, :string

      property! :suffix, :string

      property! :order, :string

      # The researcher's ORCID number. See https://orcid.org/.
      property! :orcid, :string

      # The researcher's ISNI (International Standard Name Identifier). See https://isni.org/.
      property! :isni, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :researcherid, :string

      # The researcher's Scopus Identifier. See https://www.scopus.com/freelookup/form/author.uri.
      property! :scopus, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :arxiv, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :era, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :era, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :orcid_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :isni_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :researcherid_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :scopus_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :arxiv_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :pubmed, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :lcnaf, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :wikidata, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :viaf, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :era_uri, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :user_primary_id, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :user_barcode, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :user_additional, :string, collection: true

      # The valid values for this parameter are controlled by a code-table.
      property! :additional_identifiers, EsploroSchema::Wrappers::AdditionalIdentifiers

      # The valid values for this parameter are controlled by a code-table.
      property! :affiliations, :string, collection: true

      # The valid values for this parameter are controlled by a code-table.
      property! :email, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :organization, :string, collection: true

      # The valid values for this parameter are controlled by a code-table.
      property! :role, :string

      # The valid values for this parameter are controlled by a code-table.
      property! :display_in_public_profile, :boolean

      # The valid values for this parameter are controlled by a code-table.
      property! :affiliation_with_desc, EsploroSchema::ComplexTypes::HashMap, collection: true

      xml do
        root "author", mixed: true

        map_element "familyname", to: :family_name
        map_element "givenname", to: :given_name
        map_element "middlename", to: :middle_name
        map_element "suffix", to: :suffix
        map_element "order", to: :order
        map_element "identifier.orcid", to: :orcid
        map_element "identifier.isni", to: :isni
        map_element "identifier.researcherid", to: :researcherid
        map_element "identifier.scopus", to: :scopus
        map_element "identifier.arxiv", to: :arxiv
        map_element "identifier.era", to: :era
        map_element "identifier.orcid.uri", to: :orcid_uri
        map_element "identifier.isni.uri", to: :isni_uri
        map_element "identifier.researcherid.uri", to: :researcherid_uri
        map_element "identifier.scopus.uri", to: :scopus_uri
        map_element "identifier.arxiv.uri", to: :arxiv_uri
        map_element "identifier.pubmed", to: :pubmed
        # Not a typo. this element breaks from the pattern.
        map_element "identifierLcnaf", to: :lcnaf
        map_element "identifier.wikidata", to: :wikidata
        map_element "identifier.viaf", to: :viaf
        map_element "identifier.era.uri", to: :era_uri
        map_element "user.primaryId", to: :user_primary_id
        map_element "user.barcode", to: :user_barcode
        map_element "user.additional", to: :user_additional
        map_element "additionalIdentifiers", to: :wrapped_additional_identifiers
        map_element "affiliation", to: :affiliations
        map_element "email", to: :email
        map_element "organization", to: :organization
        map_element "role", to: :role
        map_element "isDisplayInPublicProfile", to: :display_in_public_profile
        map_element "affiliationWithDesc", to: :affiliation_with_desc
      end
    end
  end
end
