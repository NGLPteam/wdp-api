# frozen_string_literal: true

module Schemas
  module Instances
    class WriteCoreTexts
      include Dry::Monads[:do, :result]

      include MeruAPI::Deps[
        write_full_text: "schemas.instances.write_full_text",
      ]

      TEXTS = [
        [:title, ?A],
        [:subtitle, ?B],
        [:tagline, ?B],
        [:summary, ?C],
      ].freeze

      # @param [HasSchemaDefinition] entity
      def call(entity)
        TEXTS.each do |(attr, weight)|
          yield upsert_text! entity, attr, weight
        end

        Success()
      end

      private

      # @param [HasSchema]
      def upsert_text!(entity, attr, weight)
        return Success() unless entity.respond_to?(attr)

        content = Sanitize.fragment(entity.public_send(attr))

        path = "$#{attr}$"

        value = {
          lang: "en",
          kind: "text",
          content:,
        }

        write_full_text.(entity, path, value, weight:)
      end
    end
  end
end
