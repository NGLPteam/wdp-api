# frozen_string_literal: true

module Types
  class LinkListVariantType < Types::BaseEnum
    i18n_namespace :template_enums

    i18n_default_key :variant

    define_from_pg_enum! "link_list_variant"
  end
end
