# frozen_string_literal: true

module Utility
  class Schemafy
    IS_STRUCT = AppTypes.Inherits(Dry::Struct)

    def call(schemalike)
      case schemalike
      when Dry::Schema::Processor
        schemalike
      when IS_STRUCT
        struct_to_schema schemalike
      else
        raise "Unknown input: #{schemalike.inspect}"
      end
    end

    def struct_to_schema(struct)
      converter = self

      Dry::Schema.Params do
        struct.schema.keys.each do |k|
          macro = k.respond_to?(:required?) && k.required? ? :required : :optional

          case k
          when Dry::Types::Schema::Key
            public_send(macro, k.name).value(k.type)
          when Dry::Types::Constructor
            if converter.array_of_structs?(k)
              inner_schema = converter.struct_to_schema k.type.type.member

              inner_type = AppTypes::Array.of(inner_schema.type_schema).default { [] }

              public_send(macro, k.name).value(inner_type)
            else
              inner = converter.type_for macro, k.type.type

              public_send(macro, k.name).value(inner)
            end
          else
            raise "Don't know how to process #{k.inspect}"
          end
        end
      end
    end

    def array_of?(key, matcher)
      return unless nested_primitive(key) == ::Array

      case key.type.type.member
      when matcher then true
      else
        false
      end
    end

    def array_of_structs?(key)
      array_of?(key, IS_STRUCT)
    end

    def nested_primitive(key)
      nested_type = key.type.type

      return nested_type.primitive if nested_type.respond_to?(:primitive)
    end

    def type_for(macro, raw_type)
      if macro == :optional
        raw_type.optional
      else
        raw_type
      end
    end
  end
end
