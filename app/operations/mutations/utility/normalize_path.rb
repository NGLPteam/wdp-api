# frozen_string_literal: true

module Mutations
  module Utility
    # Camelize and stringify a provided attribute path.
    class NormalizePath
      extend Dry::Core::Cache

      BASE = %w[$base].freeze

      # @param [#to_s, String, <String>, nil] path
      # @return [<String>]
      def call(path)
        fetch_or_store path do
          AppTypes::CoercibleStringList[path].map do |part|
            part.camelize(:lower)
          end.presence || BASE
        end
      end
    end
  end
end
