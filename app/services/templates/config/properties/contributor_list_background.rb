# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class ContributorListBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("contributor_list_background").dry_type
      end
    end
  end
end
