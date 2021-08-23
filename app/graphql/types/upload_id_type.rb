# frozen_string_literal: true

module Types
  class UploadIdType < Types::BaseScalar
    graphql_name "UploadID"

    description "An upload ID is used to refer to an upload within the tus infrastructure outside of the GraphQL API"

    class << self
      # Don't make the client do any parsing, accept `"/files/123456"` and produce `"123456"`
      # @param [String] input_value
      # @return [String, nil]
      def coerce_input(input_value, context)
        File.basename(input_value) if input_value.present?
      end

      # @param [#to_s] ruby_value
      # @return [String, nil]
      def coerce_result(ruby_value, context)
        ruby_value.to_s.presence
      end
    end
  end
end
