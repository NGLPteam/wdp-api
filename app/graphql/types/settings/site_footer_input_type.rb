# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::SiteFooter
    class SiteFooterInputType < Types::BaseInputObject
      include AutoHash

      description "A value for updating the site's configuration"

      argument :description, String, required: false, attribute: true,
        description: "A description that lives in the site's footer."

      argument :copyright_statement, String, required: false, attribute: true,
        description: "A copyright statement that lives in the site's footer."
    end
  end
end
