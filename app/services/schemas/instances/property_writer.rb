# frozen_string_literal: true

module Schemas
  module Instances
    # Write a single property on a schema instance.
    #
    # @see Schemas::Instances::Apply
    # @see Schemas::Instances::WriteProperty
    class PropertyWriter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :instance, Schemas::Types::SchemaInstance
        param :path, Schemas::Properties::Types::FullPath
        param :value, Schemas::Types::Any
      end

      standard_execution!

      # @return [PropertyHash]
      attr_reader :all_properties

      # @return [Schemas::Properties::Context]
      attr_reader :context

      # @return [Dry::Monads::Success(HierarchicalEntity)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield apply!
        end

        Success()
      end

      wrapped_hook! def prepare
        @context = instance.read_property_context

        @all_properties = PropertyHash.new(context.current_values)

        super
      end

      wrapped_hook! def apply
        all_properties[path] = value

        values = all_properties.to_h

        yield instance.apply_properties(values)

        super
      end
    end
  end
end
