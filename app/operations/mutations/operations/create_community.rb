# frozen_string_literal: true

module Mutations
  module Operations
    # Create a {Community}.
    #
    # @see Mutations::CreateCommunity
    # @see Mutations::Contracts::EntityInput
    class CreateCommunity
      include MutationOperations::Base
      include Mutations::Shared::CreatesEntity

      attachment! :logo, image: true

      def call(**args)
        community = Community.new

        authorize community, :create?

        create_entity! community, **args
      end
    end
  end
end
