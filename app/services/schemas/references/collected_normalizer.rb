# frozen_string_literal: true

module Schemas
  module References
    # This service is like its {Schemas::References::ScalarNormalizer scalar equivalent},
    # except that it is designed to work with and return an _array_ of referenced models.
    #
    # It accepts the same types as the scalar normalizer to provide flexibility,
    # as well as handling:
    #
    # * an array of models (conforming to the types provided in {#models})
    # * an array of encoded relay IDs
    # * an array of GlobalIDs
    #
    # Given scalar (or nil) input, it will always return an array.
    #
    # @see SchematicCollectedReference
    # @see AppTypes::GlobalIDType
    # @see RelayNode::ObjectFromId
    # @see Schemas::Properties::CompileSchema
    # @see Schemas::Properties::Scalar::Reference#normalize_schema_value_before_coercer
    # @see Schemas::Properties::Scalar::Reference#reference_normalizer_klass
    class CollectedNormalizer
      include Dry::Initializer.define -> do
        option :models, type: AppTypes::ModelClassList.constrained(min_size: 1)
      end

      include WDPAPI::Deps[object_from_id: "relay_node.object_from_id"]

      # @param [<Object>, Object] value
      # @return [<ApplicationRecord>]
      def call(value)
        process_input(value).then do |instances|
          Array(instances).compact
        end
      end

      private

      def process_input(value)
        case value
        when ActiveRecord::Relation
          call value.to_a
        when AppTypes::GlobalIDList
          GlobalID::Locator.locate_many value, only: models
        when AppTypes::GlobalIDType
          GlobalID::Locator.locate(value, only: models)
        when String
          object_from_id.call(value).value_or(nil)
        when AppTypes::StringList
          process_string_list value
        when AppTypes::ModelList, *models
          process_model_list value
        end
      end

      def process_string_list(value)
        value.map do |maybe_id|
          object_from_id.call(maybe_id).value_or(nil)
        end
      end

      def process_model_list(value)
        Array(value).select do |instance|
          models.any? do |model|
            instance.kind_of?(model)
          end
        end
      end
    end
  end
end
