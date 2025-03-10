# frozen_string_literal: true

module Harvesting
  module Metadata
    module Drops
      # For simplifying extracting attributes / scalar values from mapped data.
      module MapsDataAttrs
        extend ActiveSupport::Concern

        include Dry::Core::Constants

        included do
          defines :data_attr_mapping, type: Harvesting::Metadata::Drops::DataExtractor::Mapping

          data_attr_mapping EMPTY_HASH

          after_initialize :extract_data_attrs!
        end

        private

        # @return [void]
        def extract_data_attrs!
          self.class.data_attr_mapping.each_value do |extractor|
            value = extractor.extract(@data)

            instance_variable_set extractor.ivar, value
          end
        end

        module ClassMethods
          # @return [void]
          def data_attr!(name, raw_type = Types::Any, attr: name, default: nil)
            type = data_type_for raw_type

            extractor = Harvesting::Metadata::Drops::DataExtractor.new(name:, attr:, type:, default:)

            attr_reader extractor.name

            new_mapping = data_attr_mapping.merge(extractor.name => extractor).freeze

            data_attr_mapping new_mapping
          end

          # @return [void]
          def data_attrs!(*names, type: Types::Any)
            names.flatten!

            names.each do |name|
              data_attr!(name, type)
            end
          end

          private

          # @see Harvesting::Metadata::Types.registered_type_for
          # @param [String, Symbol, Dry::Types::Type] name_or_type
          # @return [Dry::Types::Type]
          def data_type_for(name_or_type)
            Harvesting::Metadata::Types.registered_type_for(name_or_type)
          end
        end
      end
    end
  end
end
