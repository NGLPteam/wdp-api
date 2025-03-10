# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRelationship
    class EsploroRelationship < EsploroSchema::Common::AbstractComplexType
      # Type of relation to a different asset. Only "ispartof" is supported at this time.
      property! :type, EsploroSchema::SimpleTypes::RelationType

      # Title of the higher-level asset of which the current asset is part. I.e. the journal title for a journal article. Free-text.
      property! :title, :string

      # For future use (not yet supported).
      property! :related_uri, :string

      # For future use (not yet supported).
      property! :related_url, :string

      # Asset end page. Free-text.
      property! :end_page, :string

      # Asset start page. Free-text.
      property! :start_page, :string

      # Issue number of the higher-level asset of which the current asset is part. Free-text.
      property! :issue, :string

      # Asset article number. Free-text.
      property! :article_number, :string

      # Volume number of the higher-level asset of which the current asset is part. Free-text.
      property! :volume, :string

      # The higher-level asset part. Free-text.
      property! :part, :string

      # Number of pages in the higher-level asset of which the current asset is part.
      # i.e. pages in the book if the asset is a book chapter.
      # Free-text.
      property! :pages, :string

      # The eISSN of the journal of which the asset is part.
      property! :eissn, :string

      # The ISSN of the journal of which the asset is part.
      property! :issn, :string

      # The ISBN of the book of which the asset is part.
      # Multiple values are allowed.
      property! :isbns, :string, collection: true

      # The eISBN of the book of which the asset is part.
      # Multiple values are allowed.
      property! :eisbns, :string, collection: true

      # The DOI of the asset of which the current asset is part.
      # Relevant mostly for book DOIs when the asset is a book chapter.
      # Not relevant for journal article assets.
      property! :doi, :string

      # For future use (not yet supported).
      property! :related_metadata_scheme, :string

      # For future use (not yet supported).
      property! :scheme_uri, :string

      # For future use (not yet supported).
      property! :scheme_type, :string

      # NLM (The National Library of Medicine) journal abbreviation.
      property! :nlm_abbrev, :string

      # For future use (not yet supported).
      property! :relation_category, EsploroSchema::SimpleTypes::EsploroAssetToAssetRelationshipType

      # For future use (not yet supported).
      property! :relation_type_with_desc, :string

      xml do
        root "esploroRelationship", mixed: true

        map_element "relationtype", to: :type
        map_element "relationtitle", to: :title
        map_element "relateduri", to: :related_uri
        map_element "relatedurl", to: :related_url
        map_element "epage", to: :end_page
        map_element "spage", to: :start_page
        map_element "issue", to: :issue
        map_element "article.number", to: :article_number
        map_element "volume", to: :volume
        map_element "part", to: :part
        map_element "pages", to: :pages
        map_element "identifier.eissn", to: :eissn
        map_element "identifier.issn", to: :issn
        map_element "identifier.isbn", to: :isbns
        map_element "identifier.eisbn", to: :eisbns
        map_element "identifier.doi", to: :doi
        map_element "relatedmetadatascheme", to: :related_metadata_scheme
        map_element "schemeuri", to: :scheme_uri
        map_element "schemetype", to: :scheme_type
        map_element "nlm.abbrev", to: :nlm_abbrev
        map_element "relation.category", to: :relation_category
        map_element "relationTypeWithDesc", to: :relation_type_with_desc
      end
    end
  end
end
