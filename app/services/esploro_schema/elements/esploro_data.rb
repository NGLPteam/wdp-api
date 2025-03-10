# frozen_string_literal: true

module EsploroSchema
  module Elements
    # @note This element does not actually exist in the spec,
    #   but the esploro data we are receiving has it, and it seems
    #   to have most/all the same elements as the top-level `<record/>`
    #   element. Thus, in our implementation, we treat this as a base
    #   class that `<record/>` extends and implements as an additional
    #   `<data/>` element in its children.
    # @see EsploroSchema::Elements::EsploroRecord
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRecord
    class EsploroData < EsploroSchema::Common::AbstractElement
      # Asset DOI (Digital Object Identifier). For more information see https://www.doi.org/.
      property! :doi, :string

      # Asset PMID (PubMed ID). For more information see https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/.
      property! :pmid, :string

      # Asset PMCID (PubMed Central ID). For more information see https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/.
      property! :pmcid, :string

      # Asset ISMN (International Standard Music Number for Notated Music). For more information see https://www.ismn-international.org/.
      property! :ismn, :string, collection: true

      # NOT IN USE
      property! :issn, :string, collection: true

      # NOT IN USE
      property! :eissn, :string, collection: true

      # Asset ISBN (International Standard Book Number). Multiple values are allowed. For more information see https://www.isbn-international.org/.
      property! :isbns, :string, collection: true

      # Asset Electronic ISBN (International Standard Book Number). Multiple values are allowed. For more information see https://www.isbn-international.org/.
      property! :eisbns, :string, collection: true

      # Asset Uniform Resource Identifier (URI). For more information see https://www.w3.org/Addressing/URL/URI_Overview.html.
      property! :uri, :string

      # Use this field for an asset identifier that does not have a designated field.
      property! :other_identifier, :string

      # Government Documents Number. Relevant for patents.
      property! :govtnum, :string, collection: true

      # Asset WoS (Web of Science) accession number. For more information see https://images.webofknowledge.com/images/help/WOS/hs_accession_number.html.
      property! :wos, :string

      # Asset Scopus electronic identification.
      property! :scopus, :string

      # Asset arXiv identifier. For more information see https://arxiv.org/help/arxiv_identifier.
      property! :arxiv, :string

      # Asset ARK (Archival Resource Key) Identifier. For more information see https://arks.org/e/ark_ids.html.
      property! :ark, :string

      # Asset SICI (Serial Item and Contribution Identifier).
      property! :sici, :string

      # Report number.
      property! :rno, :string

      # Asset Handle.Net Identifier. For more information see http://handle.net/.
      property! :handle, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_01, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_02, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_03, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_04, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_05, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_06, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_07, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_08, :string

      # Locally defined additional identifier. Must be enabled in the Asset Identifier Display Table.
      property! :additional_identifier_09, :string

      # Anticipated task duration. Free-text.
      property! :time_required, :string

      # Course name. Free-text.
      property! :course_name, :string

      # Course number. Free-text.
      property! :course_number, :string, collection: true

      # Whether it can be used on mobile. Valid values are yes/no/unknown. Defaults to unknown.
      property! :mobile_compatibility, EsploroSchema::SimpleTypes::YesNoUnknown

      # Whether it can be used on mobile. Valid values are yes/no/unknown. Defaults to unknown.
      property! :source_code_availability, EsploroSchema::SimpleTypes::YesNoUnknown

      # A list of the creators of the asset.
      property! :creators, EsploroSchema::Wrappers::Creators, collection: true

      # A list of the contributors to the asset.
      property! :contributors, EsploroSchema::Wrappers::Contributors, collection: true

      # A list of geolocations associated with the asset. May be of multiple types and have multiple values.
      property! :geo_location, EsploroSchema::ComplexTypes::EsploroGeoLocation, collection: true

      # Section describing the asset event information.
      property! :event, EsploroSchema::ComplexTypes::EsploroEvent

      # Section describing the links attached to the asset.
      property! :links, EsploroSchema::Wrappers::Links

      # Esploro Assessment Profile
      property! :national_assessments_profiles, EsploroSchema::Wrappers::NationalAssessmentsProfiles, collection: true

      # Asset title. Mandatory.
      property! :title, :string

      # Asset sub-title.
      property! :subtitle, :string

      # Asset alternative title. Multiple values are allowed.
      property! :alternative_titles, :string, collection: true

      # Asset translated title. Multiple values are allowed.
      property! :translated_titles, :string, collection: true

      # Asset other title. Multiple values are allowed.
      property! :other_titles, :string, collection: true

      # Publisher. Free-text.
      property! :publisher, :string

      # Place of publication. Free-text. Multiple values are allowed.
      property! :publication_places, :string, collection: true

      # Asset series information. Free-text field. Multiple values are allowed.
      property! :series, :string, collection: true

      # Asset series number. Free-text.
      property! :series_number, :string

      # Date asset presented. The required format is YYYYMMDD.
      property! :date_presented, :string

      # Date asset published. The required format is YYYYMMDD.
      property! :date_published, :string

      # Date asset was accepted for publishing. The required format is YYYYMMDD.
      property! :date_accepted, :string

      # Date asset was made available. The required format is YYYYMMDD.
      property! :date_available, :string

      # Date the research was collected. The required format is YYYYMMDD - YYYYMMDD.
      property! :date_collected, :string

      # Date asset was copyrighted. The required format is YYYYMMDD.
      property! :date_copyrighted, :string

      # Date the research was created. The required format is YYYYMMDD - YYYYMMDD.
      property! :date_created, :string

      # Date asset was issued. The required format is YYYYMMDD.
      property! :date_issued, :string

      # Date asset was submitted for publication. The required format is YYYYMMDD.
      property! :date_submitted, :string

      # Date asset was posted online. The required format is YYYYMMDD.
      property! :date_posted, :string

      # Date asset published online. The required format is YYYYMMDD.
      property! :date_epublished, :string

      # Date asset was updated. The required format is YYYYMMDD.
      # Multiple values are allowed.
      property! :dates_updated, :string, collection: true

      # Other date. The required format is YYYYMMDD.
      # Multiple values are allowed.
      property! :dates_other, :string, collection: true

      # Date the research is valid. The required format is YYYYMMDD - YYYYMMDD.
      property! :date_valid, :string

      # Date ETD was approved.
      property! :date_approved, :string

      # Date manuscript was completed.
      property! :date_completed, :string

      # Degree award date.
      property! :date_degree, :string

      # Date patent application was submitted. The required format is YYYYMMDD.
      property! :date_application, :string

      # Date patent was renewed. The required format is YYYYMMDD.
      property! :date_renewed, :string

      # Date ETD was defended. The required format is YYYYMMDD.
      property! :date_defense, :string

      # Performance opening date. The required format is YYYYMMDD.
      property! :date_opening, :string

      # Performance date. The required format is YYYYMMDD.
      # Multiple values are allowed.
      property! :dates_performance, :string, collection: true

      # Record views in discovery. Calculated field. Do not insert any values here.
      property! :asset_views, :integer

      # File views/downloads. Calculated field. Do not insert any values here.
      property! :asset_downloads, :integer

      # The Esploro resource (asset type). Mandatory. Use value from code table.
      property! :resource_type_esploro, EsploroSchema::SimpleTypes::EsploroResourceType

      # Sustainability Goals. Use value from code table.
      property! :sdg, :string, collection: true

      # Asset research topics. Use value from code table.
      # Multiple values are allowed.
      # Not relevant to ANZ institutions.
      property! :subject_esploro, :string, collection: true

      # List of ANZ Fields of Research. Multiple values are allowed. Not relevant to all institutions. Use values from ANZFieldsofResearchCodes table.
      property! :subject_anzfor, EsploroSchema::ComplexTypes::EsploroANZSubject, collection: true

      # List of ANZ Socio-Economic Objectives. Multiple values are allowed. Not relevant to all institutions. Use values from ANZSocio-EconomicCodes table.
      property! :subject_anzseo, EsploroSchema::ComplexTypes::EsploroANZSubject, collection: true

      # ANZ Type of Activity. Use value from code table.
      property! :subject_anztoa, :string, collection: true

      # For future use (not yet supported).
      property! :discipline_summon, :string

      # Use if there is no language specified. Asset additional subjects.
      # Multiple values are allowed.
      # Free-text.
      # Language is entered as undefined.
      # If section "keywordsTranslations" is used for import,
      # data in "keywords" will not be imported.
      property! :keywords, :string, collection: true

      # Section describing the keywords and their language.
      # Use when the language of the keywords is known.
      property! :keywords_translations, EsploroSchema::ComplexTypes::KeywordsTranslation

      # Asset relationship of type "ispartof".
      property! :relationships, EsploroSchema::Wrappers::Relationships, collection: true

      # List of asset to asset relationships.
      property! :relations, EsploroSchema::Wrappers::Relations, collection: true

      # Asset size (dimensions).
      # Multiple values are allowed. Free-text.
      property! :sizes, :string, collection: true

      # Duration. An amount of time or a particular time interval.
      property! :extent, :string

      # Asset format or media type.
      # Multiple values are allowed. Free-text.
      property! :formats, :string, collection: true

      # For future use (not yet supported).
      property! :medium, :string

      # Asset edition. Free-text.
      property! :edition, :string

      # For future use (not yet supported).
      property! :version, :string, collection: true

      # For future use (not yet supported).
      property! :accrualpolicy, :string, collection: true

      # For future use (not yet supported).
      property! :accrualperiodcity, :string, collection: true
      # For future use (not yet supported).
      property! :accrualmethod, :string, collection: true

      # Is the publication open access? Valid values are "yes", "no", "unknown". Field is informative and isn't used for calculations.
      property! :open_access, EsploroSchema::SimpleTypes::AccessStatus

      # Is the publication peer-reviewed? Valid values are "yes", "no", "unknown". Field is informative and isn't used for calculations.
      property! :peer_review, EsploroSchema::SimpleTypes::AccessStatus

      # For future use (not yet supported).
      property! :rights_list, EsploroSchema::Wrappers::RightsList, collection: true

      # For future use (not yet supported).
      property! :provenance, :string

      # For future use (not yet supported).
      property! :license, :string

      # Who owns the copyright of the asset. Free-text.
      property! :copyright, :string

      # For future use (not yet supported).
      property! :access_rights_fixed_date, :string

      # Use if there is no language specified. Asset abstract. Free-text. Multiple values are allowed. Language is entered as undefined.
      # If section "descriptionAbstractTranslations" is used for import, data in "description.abstract" will not be imported.
      property! :description_abstract, :string

      # Section describing the abstract/s and their language. Use when the language of the abstract/s is known.
      property! :description_abstract_translations, EsploroSchema::ComplexTypes::DescriptionAbstractTranslation

      # Methods used for the research or for creating this asset. Free-text.
      # Multiple values are allowed.
      property! :description_methods, :string, collection: true

      # For future use (not yet supported).
      property! :description_seriesinformation, :string, collection: true

      # Asset table of contents.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_tableofcontents, :string, collection: true

      # Asset or research coverage.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_coverage, :string, collection: true

      # The audience for which the asset is intended.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_audience, :string, collection: true

      # The education level for which the asset is intended.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_educationlevel, :string, collection: true

      # The instructional method of the asset.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_instructionalmethod, :string, collection: true

      # For future use (not yet supported).
      property! :description_mediator, :string, collection: true

      # Technical information pertaining to the asset or research.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_technicalinfo, :string, collection: true

      # Spatial information pertaining to the asset or research.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_spatial, :string, collection: true

      # Temporal information pertaining to the asset or research.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_temporal, :string, collection: true

      # Other information pertaining to the asset or research.
      # Free-text field.
      # Multiple values are allowed.
      property! :description_other, :string, collection: true

      # Description of illustrations within the asset.
      # Free-text field.
      property! :description_illustrations, :string

      # Bibliographic information pertaining to the asset.
      # Free-text field.
      property! :description_bibliographic, :string

      # Comment on the asset.
      # Free-text field.
      # Multiple values are allowed.
      property! :comments, :string, collection: true

      # Three letter language code. Multiple values are allowed. Use value from code table.
      property! :language, :string

      # For future use (not yet supported).
      property! :funding_reference_list, EsploroSchema::Wrappers::FundingReferenceList, collection: true

      # The conference name. Free-text.
      property! :conference_name, :string

      # Conference serial number. Free-text.
      property! :conference_number, :string, collection: true

      # Venue of the conference. Free-text.
      property! :conference_location, :string, collection: true

      # Date the conference took place. The required format is YYYYMMDD - YYYYMMDD.
      property! :conference_date, :string, collection: true

      # Asset PQDT Identifier (ProQuest Dissertations and Theses ID).
      # For more information see https://www.proquest.com/products-services/pqdtglobal.html
      property! :pqdt, :string

      # Number of pages in the asset. Free-text.
      property! :pages, :string

      # Information pertaining specifically to ETDs.
      property! :etd, EsploroSchema::ComplexTypes::EsploroETD

      # Information pertaining specifically to patents.
      property! :patent, EsploroSchema::ComplexTypes::EsploroPatent

      # Information on the repository in which the asset was originally stored.
      property! :original_repository, EsploroSchema::ComplexTypes::EsploroOriginalRepository

      # Esploro asset subtypes. Only relevant for certain asset types. Use value from code table.
      property! :resource_subtype, :string

      # Section describing the files attached to the asset.
      property! :files_list, EsploroSchema::Wrappers::FilesList, collection: true

      # Fields for information not stored directly on the asset.
      property! :temporary, EsploroSchema::ComplexTypes::EsploroTemporaryData

      # Locally defined asset fields. Must be defined in the "Local Field Names" configuration table.
      property! :local_fields, EsploroSchema::ComplexTypes::EsploroLocalFields

      # Free-text note about the asset grant/s.
      property! :grants_note, :string

      # Number of unpaginated pages. Free-text.
      property! :pages_unpaginated, :string

      # Season asset published. Use value from code table.
      property! :season_published, :string

      # Season degree received. Use value from code table.
      property! :season_degree, :string

      # For internal purposes only.
      # Multiple values allowed
      property! :asset_affiliations, :string, collection: true

      # Calculated field. Do not insert any values here.
      property! :asset_deposit_status, :string, collection: true

      # Calculated field. Do not insert any values here.
      property! :deposit_status_with_desc, :string, collection: true

      # Should the asset be displayed in the research portal?
      # Valid values are "true" or "false".
      # If the asset is not approved, value should be false.
      property! :portal_visibility, :boolean
      # Should the asset be displayed in the researcher profiles?
      # Valid values are "true" or "false".
      # If the asset is not approved, value should be false.
      property! :profile_visibility, :boolean, collection: true

      # Calculated field. Do not insert any values here.
      property! :subject_anz_toa_with_desc, :string

      # Has the researcher accepted the institution deposit policy?
      # If yes, policy name and date accepted are mandatory.
      property! :deposit_policy, EsploroSchema::ComplexTypes::EsploroDepositPolicy

      xml do
        root "data", mixed: true

        namespace EsploroSchema::Constants::NS_MARC_21_SLIM

        map_element "identifier.doi", to: :doi
        map_element "identifier.pmid", to: :pmid
        map_element "identifier.pmcid", to: :pmcid
        map_element "identifier.ismn", to: :ismn
        map_element "identifier.issn", to: :issn
        map_element "identifier.eissn", to: :eissn
        map_element "identifier.isbn", to: :isbns
        map_element "identifier.eisbn", to: :eisbns
        map_element "identifier.uri", to: :uri
        map_element "identifier.other", to: :other_identifier
        map_element "identifier.govtnum", to: :govtnum
        map_element "identifier.wos", to: :wos
        map_element "identifier.scopus", to: :scopus
        map_element "identifier.arxiv", to: :arxiv
        map_element "identifier.ark", to: :ark
        map_element "identifier.sici", to: :sici
        map_element "identifier.rno", to: :rno
        map_element "identifier.handle", to: :handle
        map_element "identifier.additional01", to: :additional_identifier_01
        map_element "identifier.additional02", to: :additional_identifier_02
        map_element "identifier.additional03", to: :additional_identifier_03
        map_element "identifier.additional04", to: :additional_identifier_04
        map_element "identifier.additional05", to: :additional_identifier_05
        map_element "identifier.additional06", to: :additional_identifier_06
        map_element "identifier.additional07", to: :additional_identifier_07
        map_element "identifier.additional08", to: :additional_identifier_08
        map_element "identifier.additional09", to: :additional_identifier_09
        map_element "timeRequired", to: :time_required
        map_element "courseName", to: :course_name
        map_element "courseNumber", to: :course_number
        map_element "mobileCompatibility", to: :mobile_compatibility
        map_element "sourceCodeAvailability", to: :source_code_availability
        map_element "creators", to: :wrapped_creators
        map_element "contributors", to: :wrapped_contributors
        map_element "geoLocation", to: :geo_location
        map_element "event", to: :event
        map_element "links", to: :wrapped_links
        map_element "nationalAssessmentsProfiles", to: :wrapped_national_assessments_profiles
        map_element "title", to: :title
        map_element "title.subtitle", to: :subtitle
        map_element "title.alternative", to: :alternative_titles
        map_element "title.translated", to: :translated_titles
        map_element "title.other", to: :other_titles
        map_element "publisher", to: :publisher
        map_element "publication.place", to: :publication_places
        map_element "series", to: :series
        map_element "series.number", to: :series_number
        map_element "date.presented", to: :date_presented
        map_element "date.published", to: :date_published
        map_element "date.accepted", to: :date_accepted
        map_element "date.available", to: :date_available
        map_element "date.collected", to: :date_collected
        map_element "date.copyrighted", to: :date_copyrighted
        map_element "date.created", to: :date_created
        map_element "date.issued", to: :date_issued
        map_element "date.submitted", to: :date_submitted
        map_element "date.posted", to: :date_posted
        map_element "date.epublished", to: :date_epublished
        map_element "date.updated", to: :dates_updated
        map_element "date.other", to: :dates_other
        map_element "date.valid", to: :date_valid
        map_element "date.approved", to: :date_approved
        map_element "date.completed", to: :date_completed
        map_element "date.degree", to: :date_degree
        map_element "date.application", to: :date_application
        map_element "date.renewed", to: :date_renewed
        map_element "date.defense", to: :date_defense
        map_element "date.opening", to: :date_opening
        map_element "date.performance", to: :dates_performance
        map_element "asset.views", to: :asset_views
        map_element "asset.downloads", to: :asset_downloads
        map_element "resourcetype.esploro", to: :resource_type_esploro
        map_element "sdg", to: :sdg
        map_element "subject.esploro", to: :subject_esploro
        map_element "subject.anzfor", to: :subject_anzfor
        map_element "subject.anzseo", to: :subject_anzseo
        map_element "subject.anztoa", to: :subject_anztoa
        map_element "discipline.summon", to: :discipline_summon
        map_element "keywords", to: :keywords
        map_element "keywordsTranslations", to: :keywords_translations
        map_element "relationships", to: :wrapped_relationships
        map_element "relations", to: :wrapped_relations
        map_element "size", to: :sizes
        map_element "extent", to: :extent
        map_element "format", to: :formats
        map_element "medium", to: :medium
        map_element "edition", to: :edition
        map_element "version", to: :version
        map_element "accrualpolicy", to: :accrualpolicy
        map_element "accrualperiodcity", to: :accrualperiodcity
        map_element "accrualmethod", to: :accrualmethod
        map_element "openaccess", to: :open_access
        map_element "peerreview", to: :peer_review
        map_element "rightsList", to: :wrapped_rights_list
        map_element "provenance", to: :provenance
        map_element "license", to: :license
        map_element "copyright", to: :copyright
        map_element "accessRightsFixedDate", to: :access_rights_fixed_date
        map_element "description.abstract", to: :description_abstract
        map_element "descriptionAbstractTranslations", to: :description_abstract_translations
        map_element "description.methods", to: :description_methods
        map_element "description.seriesinformation", to: :description_seriesinformation
        map_element "description.tableofcontents", to: :description_tableofcontents
        map_element "description.coverage", to: :description_coverage
        map_element "description.audience", to: :description_audience
        map_element "description.educationlevel", to: :description_educationlevel
        map_element "description.instructionalmethod", to: :description_instructionalmethod
        map_element "description.mediator", to: :description_mediator
        map_element "description.technicalinfo", to: :description_technicalinfo
        map_element "description.spatial", to: :description_spatial
        map_element "description.temporal", to: :description_temporal
        map_element "description.other", to: :description_other
        map_element "description.illustrations", to: :description_illustrations
        map_element "description.bibliographic", to: :description_bibliographic
        map_element "comment", to: :comments
        map_element "language", to: :language
        map_element "fundingreferenceList", to: :wrapped_funding_reference_list
        map_element "conferencename", to: :conference_name
        map_element "conferencenumber", to: :conference_number
        map_element "conferencelocation", to: :conference_location
        map_element "conferencedate", to: :conference_date
        map_element "identifier.pqdt", to: :pqdt
        map_element "pages", to: :pages
        map_element "etd", to: :etd
        map_element "patent", to: :patent
        map_element "originalRepository", to: :original_repository
        map_element "resource.subtype", to: :resource_subtype
        map_element "filesList", to: :wrapped_files_list
        map_element "temporary", to: :temporary
        map_element "local.fields", to: :local_fields
        map_element "grants.note", to: :grants_note
        map_element "pages.unpaginated", to: :pages_unpaginated
        map_element "season.published", to: :season_published
        map_element "season.degree", to: :season_degree
        map_element "asset.affiliation", to: :asset_affiliations
        map_element "asset.deposit.status", to: :asset_deposit_status
        map_element "depositStatusWithDesc", to: :deposit_status_with_desc
        map_element "portal_visibility", to: :portal_visibility
        map_element "profile_visibility", to: :profile_visibility
        map_element "subjectAnzToaWithDesc", to: :subject_anz_toa_with_desc
        map_element "depositPolicy", to: :deposit_policy
      end
    end
  end
end
