# frozen_string_literal: true

module Testing
  module GQL
    class SchemaPropertiesShaper < ObjectsShaper
      UNSET = Object.new.freeze

      def initialize(path_prefix: nil)
        super()

        @path_prefix = path_prefix
      end

      def group(path, &)
        item do |b|
          b.typename "GroupProperty"

          b[:path] = path.to_s

          b.schema_properties key: :properties, prefix: path.to_s do |sp|
            yield sp
          end
        end
      end

      ::Schemas::Properties::Scalar::Base.descendants.each do |klass|
        if klass.complex?
          define_method(klass.type_reference) do |path, value: UNSET, skip_value: false, &block|
            item do |b|
              b.typename klass.graphql_typename
              b[:path] = path.to_s
              b[:full_path] = normalize_full_path(path)

              return if skip_value

              set_method = :"set_#{klass.type_reference}!"

              if respond_to?(set_method, true)
                b[klass.graphql_value_key] = __send__(set_method, provided_value: value, &block)
              elsif block.present?
                b.prop(klass.graphql_value_key, &block)
              else
                b[klass.graphql_value_key] = value == UNSET ? nil : value
              end
            end
          end
        else
          define_method(klass.type_reference) do |path, value = UNSET|
            item do |b|
              b.typename klass.graphql_typename
              b[:path] = path.to_s
              b[:full_path] = normalize_full_path(path)

              b[klass.graphql_value_key] = value unless value == UNSET
            end
          end
        end
      end

      private

      def normalize_full_path(path)
        [@path_prefix, path].compact.join(?.)
      end

      def set_variable_date!(provided_value: UNSET, &block)
        ObjectShaper.build do |obj|
          obj[:value] = nil
          obj[:precision] = "NONE"

          if provided_value != UNSET
            parsed = ::VariablePrecisionDate.parse provided_value

            unless parsed.none?
              obj[:value] = parsed.value.as_json
              obj[:precision] = ::Types::DatePrecisionType.name_for_value parsed.precision
            end
          end

          yield obj if block_given?
        end
      end
    end
  end
end
