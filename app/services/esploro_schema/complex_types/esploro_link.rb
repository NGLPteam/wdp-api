# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroLink
    class EsploroLink < EsploroSchema::Common::AbstractComplexType
      property! :url, :string
      property! :type, :string
      property! :description, :string
      property! :title, :string
      property! :rights, :string
      property! :supplemental, :boolean
      property! :license, :string
      property! :ownership, :string
      property! :order, :integer
      property! :display_in_viewer, :boolean
      property! :rights_reason, :string
      property! :embargo_end, :date

      xml do
        root "link", mixed: true

        map_element "link.url", to: :url
        map_element "link.type", to: :type
        map_element "link.description", to: :description
        map_element "link.title", to: :title
        map_element "link.rights", to: :rights
        map_element "link.supplemental", to: :supplemental
        map_element "link.license", to: :license
        map_element "link.ownership", to: :ownership
        map_element "link.order", to: :order
        map_element "link.display_in_viewer", to: :display_in_viewer
        map_element "link.rightsreason", to: :rights_reason
        map_element "link.embargoend", to: :embargo_end
      end
    end
  end
end
