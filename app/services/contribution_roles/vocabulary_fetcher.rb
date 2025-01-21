# frozen_string_literal: true

module ContributionRoles
  # @see ContributionRoles::FetchVocabulary
  class VocabularyFetcher < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :contributable, ContributionRoles::Types::Contributable.optional, optional: true
    end

    standard_execution!

    # @return [ContributionRoleConfiguration]
    attr_reader :contribution_role_configuration

    # @return [ControlledVocabulary]
    attr_reader :vocabulary

    # @return [Dry::Monads::Success(ControlledVocabulary)]
    def call
      run_callbacks :execute do
        yield prepare!
      end

      Success vocabulary
    end

    wrapped_hook! def prepare
      @contribution_role_configuration = call_operation!("contribution_roles.fetch_config", contributable:)

      @vocabulary = contribution_role_configuration.controlled_vocabulary

      super
    end
  end
end
