# frozen_string_literal: true

module Searching
  module Compilation
    # Create an idempotent, opaque, database-identifier-safe name for
    # building joins for ordering based on the `path` provided.
    #
    # @api private
    class EncodeJoinName
      # @param [String] path
      # @return [String]
      def call(path)
        Base64.urlsafe_encode64(path, padding: false)
      end
    end
  end
end
