# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class ContributorListFilter < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("contributor_list_filter").dry_type
      end
    end
  end
end
