# frozen_string_literal: true

module Schemas
  module Instances
    # @see Schemas::Instances::PatchProperties
    class PropertiesPatcher < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :instance, Schemas::Types::SchemaInstance

        param :new_properties, Schemas::Types::Hash, default: proc { {} }
      end

      standard_execution!

      # @return [::Support::PropertyHash]
      attr_reader :all_properties

      # @return [Schemas::Properties::Context]
      attr_reader :context

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield prepare!

          yield patch!
        end

        Success()
      end

      wrapped_hook! def prepare
        @context = instance.read_property_context

        @all_properties = ::Support::PropertyHash.new(context.current_values)

        super
      end

      wrapped_hook! def patch
        new_properties.each do |path, value|
          all_properties[path] = value
        end

        values = all_properties.to_h

        yield instance.apply_properties(values)

        super
      end
    end
  end
end
