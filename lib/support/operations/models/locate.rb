# frozen_string_literal: true

module Support
  module Models
    # Try to look up a single GlobalID.
    class Locate
      include Dry::Monads[:result]

      # @param [GlobalID, String] global_id
      # @return [Dry::Monads::Success(ApplicationRecord)]
      def call(global_id, only: nil)
        actual = GlobalID.parse global_id

        return Failure[:invalid_global_id] unless actual

        model = GlobalID.find actual, only:
      rescue ActiveRecord::RecordNotFound
        Failure[:not_found]
      rescue NameError
        Failure[:invalid_global_id]
      else
        Success model
      end
    end
  end
end
