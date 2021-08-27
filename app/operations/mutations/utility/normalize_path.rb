# frozen_string_literal: true

module Mutations
  module Utility
    # Camelize and stringify a provided attribute path.
    class NormalizePath
      extend Dry::Core::Cache

      BASE = %w[$base].freeze

      # @param [#to_s, String, <String>, nil] path
      # @return [<String>, nil]
      def call(path)
        return BASE if path.nil?

        fetch_or_store path do
          AppTypes::AttributePath[path].map do |part|
            part.kind_of?(Integer) ? part : part.camelize(:lower)
          end.presence || BASE
        end
      end
    end
  end
end
