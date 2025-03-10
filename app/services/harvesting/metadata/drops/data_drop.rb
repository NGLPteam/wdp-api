# frozen_string_literal: true

module Harvesting
  module Metadata
    module Drops
      # This is a drop around a piece of data, usually a {Shale::Mapper} or similar,
      # that iterates through its data and exposes more content.
      #
      # @abstract
      class DataDrop < Abstract
        include Harvesting::Metadata::Drops::MapsDataAttrs

        private

        def data_subdrops(drop_klass, data_list)
          Array(data_list).map do |data|
            subdrop drop_klass, data
          end.compact
        end

        # @param [Object] data
        def set_up!(data, **kwargs)
          super

          @data = data
        end

        class << self
          def data_subdrops!(drop_klass, attr, expose_first: false, singular: attr.to_s.singularize, plural: attr.to_s.pluralize)
            attr_reader plural.to_sym

            extract_method = :"extract_#{plural}!"

            if expose_first
              attr_reader singular.to_sym

              class_eval <<~RUBY, __FILE__, __LINE__ + 1
              # @return [void]
              def #{extract_method}
                @#{plural} = data_subdrops #{drop_klass.name}, @data.#{attr}

                @#{singular} = @#{plural}.first
              end
              RUBY
            else
              alias_method singular.to_sym, plural.to_sym

              class_eval <<~RUBY, __FILE__, __LINE__ + 1
              # @return [void]
              def #{extract_method}
                @#{plural} = data_subdrops #{drop_klass.name}, @data.#{attr}
              end
              RUBY
            end

            private extract_method

            after_initialize extract_method
          end
        end
      end
    end
  end
end
