# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateCommunity
      include MutationOperations::Base
      include MutationOperations::UpdatesEntity

      def call(community:, **attributes)
        authorize community, :update?

        update_entity! community, attributes
      end
    end
  end
end
