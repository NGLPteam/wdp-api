# frozen_string_literal: true

module Types
  module QueriesSystem
    include Types::BaseInterface
    include Dry::Core::Constants

    description <<~TEXT
    Fields for querying system-level information about the current installation.
    TEXT

    implements Types::QueriesUser

    field :analytics, Types::AnalyticsType, null: false do
      description "Access top-level analytics."
    end

    field :global_configuration, Types::GlobalConfigurationType, null: false do
      description "Fetch the global configuration for this installation"
    end

    field :system_info, Types::SystemInfoType, null: false do
      description "A helper field that is used to look up various details about the WDP-API ecosystem."
    end

    # @return [void]
    def analytics
      EMPTY_HASH
    end

    # @return [GlobalConfiguration]
    def global_configuration
      GlobalConfiguration.fetch
    end

    def system_info
      viewer
    end
  end
end
