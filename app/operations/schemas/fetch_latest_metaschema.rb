# frozen_string_literal: true

module Schemas
  class FetchLatestMetaschema
    include Dry::Monads[:result]
    include Schemas::Static::Import[map: "metaschemas.map"]

    def call(name)
      versions = map[name]

      versions.validate!
    rescue Dry::Container::Error => e
      Failure[:invalid_metaschema_name, e.message]
    rescue ActiveModel::ValidationError => e
      Failure[:invalid_metaschema_versions, e.message]
    else
      Success versions.latest
    end
  end
end
