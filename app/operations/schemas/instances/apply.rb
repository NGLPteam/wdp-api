# frozen_string_literal: true

module Schemas
  module Instances
    # Validates and saves schema values from any source to an entity.
    #
    # Values must be provided as a whole—there is presently no "patch" feature,
    # owing to the complexity of the inputs. Adding a merge/patch may happen later.
    class Apply
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[validate_properties: "schemas.properties.validate", apply_value_context: "schemas.instances.apply_value_context"]
      include MonadicPersistence

      prepend TransactionalCall

      MESSAGES = {
        invalid_target: "%<klass>s is not a schema instance"
      }.freeze

      # @param [HasSchemaDefinition] entity
      # @param [#to_h] values
      # @return [Dry::Monads::Result]
      def call(entity, values)
        target, _definition, version = yield validate_target! entity

        yield check_and_assign_version! target, version

        validated_values = yield validate_properties! version, values

        yield write_values! target, version, validated_values

        monadic_save target
      end

      private

      # @param [HasSchemaDefinition] entity
      # @return [Dry::Monads::Result::Success(HasSchemaDefinition, SchemaDefinition, SchemaVersion)]
      # @return [Dry::Monads::Result::Failure(:invalid_target, String)]
      def validate_target!(entity)
        return fail_with(:invalid_target, klass: entity.class.inspect) unless entity.kind_of?(HasSchemaDefinition)

        Success[entity, entity.schema_definition, entity.schema_version]
      end

      # @todo This should check that we are not overwriting a different version once
      #   we support more diverse schema declarations.
      #
      # @return [Dry::Monads::Result]
      def check_and_assign_version!(target, version)
        target.properties ||= {}

        target.properties.schema = version.to_declaration

        Success nil
      end

      # @see Schemas::Properties::Validate
      # @param [SchemaVersion] version
      # @param [Hash] values
      # @return [Dry::Monads::Result::Success(Dry::Validation::Result)]
      # @return [Dry::Mondas::Result::Failure(:invalid_values, Dry::Validation::Result)]
      def validate_properties!(version, values)
        validate_properties.call version, values
      end

      # @see Schemas::Instances::ApplyValueContext
      # @param [SchemaVersion] version
      # @param [Dry::Validation::Result] values
      # @return [Dry::Monads::Result]
      def write_values!(entity, version, values)
        write_context = Schemas::Properties::WriteContext.new entity, version, values

        version.configuration.properties.each do |property|
          yield property.write_values_within! write_context
        end

        value_context = yield write_context.finalize

        apply_value_context.call entity, value_context
      end

      def fail_with(key, **format_args)
        Failure[key, MESSAGES[key] % format_args]
      end
    end
  end
end