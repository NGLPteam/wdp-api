# frozen_string_literal: true

module Seeding
  module Import
    class Run
      include Dry::Core::Memoizable
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        read_or_parse_json: "utility.read_or_parse_json",
        upsert_communities: "seeding.import.upsert_communities",
        validate: "seeding.import.validate",
      ]

      # @param [Hash, String] input (@see Utility::ReadOrParseJSON)
      # @return [Dry::Monads::Result]
      def call(input)
        validated = yield load(input)

        middleware = yield build(validated)

        retval = {}

        middleware.call do |import|
          retval[:communities] = yield upsert_communities.(import)
        end

        Success retval
      end

      private

      # @param [Dry::Validation::Result] result
      # @return [Dry::Monads::Result(Seeding::Import::Middleware)]
      def build(result)
        struct = Seeding::Import::Structs::Import.new result.to_h

        middleware = Seeding::Import::Middleware.new struct

        Success middleware
      end

      # @param [Hash, String] input (@see Utility::ReadOrParseJSON)
      # @return [Dry::Monads::Success(Dry::Validation::Result)]
      def load(input)
        hashified = yield read_or_parse_json.(input)

        validate.(hashified)
      end
    end
  end
end
