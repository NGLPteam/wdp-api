# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module Reference
        extend ActiveSupport::Concern

        included do
          extend Dry::Core::ClassAttributes

          defines :model_types, type: AppTypes::ModelClassList

          memoize :reference_normalizer

          config.complex = true
          config.graphql_value_key = type_reference
        end

        def might_normalize_value_before_coercion?
          true unless exclude_from_schema?
        end

        def model_types
          self.class.model_types
        end

        def normalize_schema_value_before_coercer(raw:, **_context)
          reference_normalizer.call raw
        end

        def reference_normalizer
          reference_normalizer_klass.new models: model_types
        end

        def reference_normalizer_klass
          config.array ? Schemas::References::CollectedNormalizer : Schemas::References::ScalarNormalizer
        end

        module ClassMethods
          def model_type!(model)
            model_types! model
          end

          def model_types!(*models)
            models.flatten!

            merged_types = Array(model_types) | models

            model_types merged_types

            matcher_type = models.map do |model_klass|
              AppTypes.Instance(model_klass)
            end.reduce(&:|)

            config.schema_type = matcher_type

            config.base_type = matcher_type
          end
        end
      end
    end
  end
end
