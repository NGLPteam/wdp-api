# frozen_string_literal: true

module Support
  module Models
    # Try to find multiple GlobalIDs and ensure that the same amount provided is actually found.
    class LocateMany
      include Dry::Monads[:result, :do]

      # @param [<GlobalID, String>] global_ids
      # @param [<Class>] only
      # @return [Dry::Monads::Success<ApplicationRecord>]
      # @return [Dry::Monads::Failure(:incongruous)]
      # @return [Dry::Monads::Failure(:invalid_global_id)]
      # @return [Dry::Monads::Failure(:not_found)]
      def call(global_ids, only: nil)
        global_ids = yield parse! global_ids

        models = yield locate!(global_ids, only:)

        return Failure[:incongruous] unless models.size == global_ids.size

        Success models
      end

      private

      # @param [<GlobalID, String>] global_ids
      # @return [Dry::Monads::Success<GlobalID>]
      # @return [Dry::Monads::Failure(:incongruous)]
      def parse!(global_ids)
        ids = Array(global_ids).map { |global_id| GlobalID.parse global_id }

        return Failure[:incongruous] unless ids.all?

        Success ids
      end

      # @param [<GlobalID>] global_ids
      # @param [<Class>] only
      # @return [Dry::Monads::Success<ApplicationRecord>]
      # @return [Dry::Monads::Failure(:invalid_global_id)]
      def locate!(global_ids, only: nil)
        models = GlobalID::Locator.locate_many(global_ids, only:)
      rescue ActiveRecord::RecordNotFound
        Failure[:not_found]
      rescue NameError
        Failure[:invalid_global_id]
      else
        Success models
      end
    end
  end
end
