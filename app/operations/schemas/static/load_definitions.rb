# frozen_string_literal: true

module Schemas
  module Static
    class LoadDefinitions
      include Dry::Monads[:do, :result]
      include Schemas::Static::TracksLayoutDefinitions

      include MeruAPI::Deps[
        load_definition: "schemas.static.load_definition"
      ]

      def call
        ApplicationRecord.transaction do
          capture_layout_definitions_to_invalidate! do
            StaticSchemaDefinition.find_each do |static_definition|
              yield load_definition.call(static_definition)
            end
          end

          SchemaVersion.builtin.find_each(&:maintain_associations!)
        end

        Success true
      end
    end
  end
end
