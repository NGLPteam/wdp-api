# frozen_string_literal: true

module Schemas
  module Properties
    # A polymorphic operation to fetch a single property reader.
    #
    # @see ExposesSchemaProperties
    # @see Schemas::Properties::Fetch
    # @see Schemas::Properties::ToContext
    # @see Schemas::Properties::ToReader
    class FetchReader
      include Dry::Monads[:result, :do]
      include MeruAPI::Deps[
        fetch: "schemas.properties.fetch",
        to_context: "schemas.properties.to_context",
        to_reader: "schemas.properties.to_reader",
      ]

      # @param [ExposesSchemaProperties] source
      # @param [String] full_path
      # @param [Schemas::Properties::Context, nil] context
      # @raise [TypeError] when an invalid source is provided
      # @return [Schemas::Properties::BaseDefinition, nil]
      # @return [Schemas::Properties::Reader, Schemas::Properties::GroupReader]
      def call(source, full_path, context: nil)
        options = {}

        options[:context] = yield to_context.(source, existing: context)

        property = fetch.(source, full_path)

        return Failure[:unknown_property, "#{full_path} is not a known property"] if property.blank?

        to_reader.call property, **options
      end
    end
  end
end
