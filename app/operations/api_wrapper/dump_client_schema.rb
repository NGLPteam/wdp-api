# frozen_string_literal: true

module APIWrapper
  class DumpClientSchema
    # @return [void]
    def call
      GraphQL::Client.dump_schema APIWrapper::DefaultAdapter, APIWrapper::CLIENT_SCHEMA_PATH
    end
  end
end
