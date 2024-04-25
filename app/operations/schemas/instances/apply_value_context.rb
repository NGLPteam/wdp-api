# frozen_string_literal: true

module Schemas
  module Instances
    # Takes a {Schemas::Properties::Context} and persists it to a {HasSchemaDefinition schema instance}.
    class ApplyValueContext
      include Dry::Monads[:do, :result]

      include MonadicPersistence

      include MeruAPI::Deps[
        write_collected_references: "schemas.references.write_collected_references",
        write_full_text: "schemas.instances.write_full_text",
        write_scalar_reference: "schemas.references.write_scalar_reference"
      ]

      # @param [HasSchemaDefinition] entity
      # @param [Schemas::Properties::Context] context
      # @return [Dry::Monads::Result]
      def call(entity, context)
        yield assign_values! entity, context

        yield write_collected_references! entity, context

        yield write_full_text! entity, context

        yield write_scalar_references! entity, context

        Success entity
      end

      private

      # @param [HasSchemaDefinition] entity
      # @param [Schemas::Properties::Context] context
      # @return [Dry::Monads::Result]
      def assign_values!(entity, context)
        entity.properties.values = context.values

        monadic_save entity
      end

      # @param [HasSchemaDefinition] entity
      # @param [Schemas::Properties::Context] context
      # @return [Dry::Monads::Result]
      def write_collected_references!(entity, context)
        context.collected_references.each do |full_path, referents|
          yield write_collected_references.call entity, full_path, referents
        end

        Success nil
      end

      # @param [HasSchemaDefinition] entity
      # @param [Schemas::Properties::Context] context
      # @return [Dry::Monads::Result]
      def write_full_text!(entity, context)
        context.full_texts.each do |full_path, text|
          yield write_full_text.call entity, full_path, text
        end

        Success nil
      end

      # @param [HasSchemaDefinition] entity
      # @param [Schemas::Properties::Context] context
      # @return [Dry::Monads::Result]
      def write_scalar_references!(entity, context)
        context.scalar_references.each do |full_path, referent|
          yield write_scalar_reference.call entity, full_path, referent
        end

        Success nil
      end
    end
  end
end
