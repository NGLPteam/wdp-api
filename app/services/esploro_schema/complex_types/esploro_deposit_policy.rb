# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroDepositPolicy
    class EsploroDepositPolicy < EsploroSchema::Common::AbstractComplexType
      # Not relevant to import/export.
      property! :accepted_date, Lutaml::Model::Type::DateTime

      # Date the deposit policy was accepted. The required format is YYYYMMDD
      property! :accepted_date_policy, :string

      #  Not relevant to import/export.
      property! :metadata, :string

      # Free-text note on the researcher acceptance of the deposit policy.
      property! :note, :string

      # Name of the policy that the researcher accepted. Valid values are policy names that appear in the deposit policy configuration table.
      property! :name, :string

      # Must be text.
      property! :type, :string

      xml do
        root "policy", mixed: true

        map_element "acceptedDate", to: :accepted_date
        map_element "acceptedDatePolicy", to: :accepted_date_policy
        map_element "metadata", to: :metadata
        map_element "note", to: :note
        map_element "policyName", to: :name
        map_element "policyType", to: :type
      end
    end
  end
end
