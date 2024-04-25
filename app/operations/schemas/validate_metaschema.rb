# frozen_string_literal: true

module Schemas
  class ValidateMetaschema
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[fetch: "schemas.fetch_latest_metaschema"]

    def call(name, value)
      schema = yield fetch.call name

      schema.validate value
    end
  end
end
