# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::SiteFooter
    class SiteFooterType < Types::BaseObject
      description "A value for updating the site's configuration"

      field :description, String, null: false,
        description: "A description that lives in the site's footer."

      field :copyright_statement, String, null: false,
        description: "A copyright statement that lives in the site's footer."
    end
  end
end
