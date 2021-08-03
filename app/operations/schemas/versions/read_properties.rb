# frozen_string_literal: true

module Schemas
  module Versions
    class ReadProperties
      include Dry::Monads[:do, :list, :result]
      include WDPAPI::Deps[to_reader: "schemas.properties.to_reader"]

      # @param [SchemaVersion] schema_version
      # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
      def call(schema_version)
        options = {}

        options[:context] = Schemas::Properties::Context.new

        results = schema_version.configuration.properties.map do |property|
          to_reader.call property, options
        end

        result = yield List::Result.coerce(results).traverse

        Success result.to_a
      end
    end
  end
end
