# frozen_string_literal: true

module Harvesting
  module Contributions
    # TODO: Fix during harvesting refactor.
    class Attach
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include MeruAPI::Deps[
        attach: "contributors.attach",
        connect_or_create: "harvesting.contributors.connect_or_create",
      ]

      prepend TransactionalCall

      # @param [HarvestContribution] harvest_contribution
      # @param [Contributable] contributable
      # @return [Dry::Monads::Result]
      def call(harvest_contribution, contributable)
        Success()
      end

      private

      # @param [HarvestContribution] harvest_contribution
      # @param [Contributable] contributable
      # @return [Dry::Monads::Result]
      def original_call(harvest_contribution, contributable)
        # :nocov:
        contributor = yield connect_or_create.call(harvest_contribution.harvest_contributor)

        contribution = yield attach.call contributor, contributable

        contribution.kind = harvest_contribution.kind

        if harvest_contribution.metadata.present?
          contribution.metadata ||= {}

          contribution.metadata.corresp = harvest_contribution.metadata["corresp"].present?
        end

        monadic_save contribution
        # :nocov:
      end
    end
  end
end
