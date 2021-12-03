# frozen_string_literal: true

module Mutations
  module Operations
    # @see GlobalConfiguration
    # @see Mutations::UpdateGlobalConfiguration
    class UpdateGlobalConfiguration
      include MutationOperations::Base

      use_contract! :update_global_configuration

      def call(site: nil, theme: nil, **args)
        config = GlobalConfiguration.fetch

        authorize config, :update?

        config.site = site if site.present?

        config.theme = theme if theme.present?

        persist_model! config, attach_to: :global_configuration
      end
    end
  end
end
