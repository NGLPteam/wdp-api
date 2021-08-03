# frozen_string_literal: true

module Schemas
  module References
    # This service will normalize received input into a specific constrained set
    # of models. It allows our schemas to accept a variety of potentially-valid
    # values of the following types:
    #
    # * a single model (conforming to the types provided in {#models})
    # * an encoded relay ID
    # * a GlobalID
    #
    # This service is currently used during the normalization process when compiling
    # a schema.
    #
    # @see SchematicScalarReference
    # @see AppTypes::GlobalIDType
    # @see RelayNode::ObjectFromId
    # @see Schemas::Properties::CompileSchema
    # @see Schemas::Properties::Scalar::Reference#normalize_schema_value_before_coercer
    # @see Schemas::Properties::Scalar::Reference#reference_normalizer_klass
    class ScalarNormalizer
      include Dry::Initializer.define -> do
        option :models, type: AppTypes::ModelClassList.constrained(min_size: 1)
      end

      include WDPAPI::Deps[object_from_id: "relay_node.object_from_id"]

      # @param [Object] value
      # @return [ApplicationRecord, nil]
      def call(value)
        case value
        when AppTypes::GlobalIDType
          GlobalID::Locator.locate(value, only: models)
        when String
          object_from_id.call(value).value_or(nil)
        when *models
          value
        end
      end
    end
  end
end
