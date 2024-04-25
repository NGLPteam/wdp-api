# frozen_string_literal: true

module Schemas
  module Static
    class LoadDefinitions
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[load_definition: "schemas.static.load_definition"]
      include Schemas::Static::Import[definitions: "definitions.map"]

      def call
        ApplicationRecord.transaction do
          definitions.each_definition do |identifier, map|
            yield load_definition.call identifier, map
          end

          SchemaVersion.find_each(&:maintain_associations!)
        end

        Success true
      end
    end
  end
end
