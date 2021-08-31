# frozen_string_literal: true

module Testing
  module Requests
    class VariableTransformer
      extend Dry::Core::Cache

      include WDPAPI::Deps[:inflector]

      # @param [#to_h] hash
      # @return [{ String => Object }]
      def call(hash)
        fetch_or_store :transformed, hash do
          Dry::Types["coercible.hash"][hash].deep_transform_keys do |key|
            fetch_or_store key do
              inflector.camelize(key, false)
            end
          end
        end
      end
    end
  end
end
