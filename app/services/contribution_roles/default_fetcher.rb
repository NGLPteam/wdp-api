# frozen_string_literal: true

module ContributionRoles
  # @see ContributionRoles::FetchDefault
  class DefaultFetcher < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :contributable, ContributionRoles::Types::Contributable.optional, optional: true
    end

    standard_execution!

    # @return [ContributionRoleConfiguration]
    attr_reader :contribution_role_configuration

    # @return [ControlledVocabularyItem]
    attr_reader :default_item

    # @return [GlobalConfiguration]
    attr_reader :global_configuration

    # @return [Dry::Monads::Success(ControlledVocabularyItem)]
    def call
      run_callbacks :execute do
        yield prepare!
      end

      Success default_item
    end

    wrapped_hook! def prepare
      @contribution_role_configuration = call_operation!("contribution_roles.fetch_config", contributable:)

      @default_item = contribution_role_configuration.default_item

      super
    end
  end
end
