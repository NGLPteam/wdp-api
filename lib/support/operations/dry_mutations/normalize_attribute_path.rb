# frozen_string_literal: true

module Support
  module DryMutations
    # Camelize and stringify a provided attribute path.
    class NormalizeAttributePath
      extend Dry::Core::Cache

      BASE = %w[$base].freeze

      # @param [#to_s, String, <String>, nil] path
      # @return [<String>, nil]
      def call(path)
        return BASE if path.nil?

        fetch_or_store path do
          Support::DryMutations::Types::AttributePath[path].map do |part|
            part.kind_of?(Integer) ? part : part.camelize(:lower)
          end.presence || BASE
        end
      end
    end
  end
end
