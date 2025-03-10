# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroTemporaryData
    class EsploroTemporaryData < EsploroSchema::Common::AbstractComplexType
      # Asset license. Use value from code table.
      property! :asset_license_code, :string
      # Asset access rights policy ID. Use value from code table.
      property! :asset_access_right_policy_id, :string
      # Asset access rights policy ID. Use value from code table.
      property! :asset_access_right_name, :string
      # Asset embargo end date. Mandatory for access rights "Fixed Embargo Date". The required format is MM/DD/YYYY.
      property! :asset_access_right_date, :string

      # Calculated field. Do not insert any values here.
      property! :asset_access_right_embargo, :string

      # Asset affiliation (academic unit). Mandatory. Use code from the institution organization table.
      # Must include the numeric prefix.
      property! :asset_affiliation, :string

      # For internal purposes only.
      property! :asset_affiliation_action, EsploroSchema::SimpleTypes::ActionType

      # Calculated field. Do not insert any values here.
      property! :researcher_affiliation, :string

      # Calculated field. Do not insert any values here.
      property! :researcher_degree_program, :string, collection: true

      # Researcher acceptance of the institution deposit policy.
      property! :policy, EsploroSchema::ComplexTypes::EsploroDepositPolicy

      # Calculated field. Do not insert any values here.
      property! :asset_asset_publication_language_name, :string

      # For external ETDs. The academic unit which awarded the degree.
      # Free-text. Not mandatory.
      property! :asset_awarding_academic_unit, :string

      # Not relevant for import/export.
      property! :alt_advisor_num_set, :integer, collection: true

      # Not relevant for import/export.
      property! :alt_comm_mem_num_set, :integer, collection: true

      # List of links from which to extract files.
      property! :links_to_extract, EsploroSchema::Wrappers::LinksToExtract, collection: true

      # Not relevant for import/export.
      property! :additional_data1, :string, collection: true

      # Not relevant for import/export.
      property! :creator_organization, :string, collection: true

      # Not relevant for import/export.
      property! :contributor_organization, :string, collection: true

      # Not relevant for import/export.
      property! :researcher_ids, :string, collection: true

      xml do
        root "temporary", mixed: true

        map_element "asset.licenseCode", to: :asset_license_code
        map_element "asset.accessRightPolicyId", to: :asset_access_right_policy_id
        map_element "asset.accessRightName", to: :asset_access_right_name
        map_element "asset.accessRightDate", to: :asset_access_right_date
        map_element "asset.accessRightEmbargo", to: :asset_access_right_embargo
        map_element "asset.affiliation", to: :asset_affiliation
        map_element "asset.affiliationAction", to: :asset_affiliation_action
        map_element "researcher.affiliation", to: :researcher_affiliation
        map_element "researcher.degreeProgram", to: :researcher_degree_program
        map_element "policy", to: :policy
        map_element "asset.assetPublicationLanguageName", to: :asset_asset_publication_language_name
        map_element "asset.awardingAcademicUnit", to: :asset_awarding_academic_unit
        map_element "alt.advisor.num.set", to: :alt_advisor_num_set
        map_element "alt.comm.mem.num.set", to: :alt_comm_mem_num_set
        map_element "linksToExtract", to: :wrapped_links_to_extract
        map_element "additional.data1", to: :additional_data1
        map_element "creator.organization", to: :creator_organization
        map_element "contributor.organization", to: :contributor_organization
        map_element "researcherIds", to: :researcher_ids
      end
    end
  end
end
