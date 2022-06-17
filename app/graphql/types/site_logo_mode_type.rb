# frozen_string_literal: true

module Types
  # @see Settings::Site
  class SiteLogoModeType < Types::BaseEnum
    description "An option that determines how the site logo should be rendered"

    value "SANS_TEXT", value: "sans_text" do
      description "The site logo should be displayed with the site title _hidden_."
    end

    value "WITH_TEXT", value: "with_text" do
      description "The site logo should be displayed with the site title _visible_."
    end

    value "NONE", value: "none" do
      description "The site logo is unavailable."
    end
  end
end
