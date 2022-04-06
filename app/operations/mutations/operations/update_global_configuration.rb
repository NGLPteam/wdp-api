# frozen_string_literal: true

module Mutations
  module Operations
    # @see GlobalConfiguration
    # @see Mutations::UpdateGlobalConfiguration
    class UpdateGlobalConfiguration
      include MutationOperations::Base

      use_contract! :update_global_configuration

      def call(institution: nil, site: nil, theme: nil, **args)
        config = GlobalConfiguration.fetch

        authorize config, :update?

        config.institution = institution if institution.present?

        if site.present?
          footer = site.delete(:footer)

          config.site = config.site.as_json.deep_symbolize_keys.merge(site)

          config.site.footer = footer if footer.present?
        end

        config.theme = theme if theme.present?

        persist_model! config, attach_to: :global_configuration
      end
    end
  end
end
