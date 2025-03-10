# frozen_string_literal: true

module Harvesting
  module Metadata
    module Esploro
      # @abstract
      class AbstractEsploroDrop < Harvesting::Metadata::Drops::DataDrop
        private

        # @return [EsploroSchema::Record]
        attr_reader :record

        # @param [Lutaml::Model::Serializable] data
        def set_up!(data, **kwargs)
          super

          @record = metadata_context.record
        end

        class << self
          # @param [EsploroSchema::Common::PropertyDefinition] property
          # @return [void]
          def expose_property!(property)
            attr_reader property.normalized_name

            class_eval <<~RUBY, __FILE__, __LINE__ + 1
            after_initialize def extract_#{property.normalized_name}!
              value = @data.#{property.normalized_name}

              #{property.ivar} = value.kind_of?(Array) ? value.map(&:to_liquid) : value.to_liquid
            end

            private :extract_#{property.normalized_name}!
            RUBY
          end
        end
      end
    end
  end
end
