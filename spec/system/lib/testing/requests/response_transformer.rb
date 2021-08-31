# frozen_string_literal: true

module Testing
  module Requests
    class ResponseTransformer
      extend Dry::Core::Cache

      include WDPAPI::Deps[:inflector]

      # @param [#to_h] value
      # @return [{ String => Object }]
      def call(value, decamelize: true)
        fetch_or_store value, decamelize do
          Dry::Types["coercible.hash"][value].then do |hash|
            if decamelize
              hash.deep_transform_keys do |key|
                fetch_or_store key do
                  inflector.underscore key
                end
              end
            else
              hash
            end
          end.with_indifferent_access
        end
      end
    end
  end
end
