# frozen_string_literal: true

module Support
  module Requests
    module SetsConnectionInfo
      extend ActiveSupport::Concern

      included do
        include Dry::Effects.Resolve(:connection_info)

        delegate :wants_total_count?, :wants_unfiltered_count?, to: :safe_connection_info
      end

      def increment_total_count!(value)
        safe_connection_info.total_count += value
      end

      def increment_unfiltered_count!(value)
        safe_connection_info.unfiltered_count += value
      end

      private

      def safe_connection_info
        connection_info { Requests::ConnectionInfo.new(path: %w[unknown]) }
      end
    end
  end
end
