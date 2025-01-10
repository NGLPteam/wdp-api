# frozen_string_literal: true

module Templates
  module Refinements
    # These are refinements used by the TemplateGenerator in order to
    # more efficiently define properties, slots, etc for given templates.
    module TemplateGenerator
      refine ::Template do
        def build_declarations(indent:)
          declarations = []

          yield declarations

          declarations.compact.join("\n\n").indent(indent).strip
        end

        def definition_model_declarations(indent: 4)
          build_declarations(indent:) do |decl|
            properties.sort_by(&:model_sort_key).each do |prop|
              decl << prop.to_model_declaration
            end

            decl.compact!

            decl << slots_attribute
          end
        end

        def slots_attribute
          %[attribute :slots, ::#{slot_definition_mapping_klass_name}.to_type]
        end

        def shale_slots_attribute
          %[attribute :slots, #{config_slots_klass_name},\n  default: -> { #{config_slots_klass_name}.new }]
        end

        def shale_slots_mapping
          %[map_element "slots", to: :slots]
        end

        def config_shale_attribute_declarations(indent: 8)
          build_declarations(indent:) do |decl|
            properties.each do |prop|
              next if prop.skip_configuration? || prop.deprecated?

              decl << prop.to_shale_attribute_declaration
            end

            decl << shale_slots_attribute
          end
        end

        def config_shale_xml_mapper_declarations(indent: 10)
          build_declarations(indent:) do |decl|
            properties.each do |prop|
              next if prop.skip_configuration? || prop.deprecated?

              decl << prop.to_shale_xml_mapper_declaration
            end

            decl.sort!

            decl << shale_slots_mapping
          end
        end

        def slot_config_shale_attribute_declarations(indent: 8)
          build_declarations(indent:) do |decl|
            slots.each do |slot|
              decl << slot.to_shale_attribute_declaration
            end
          end
        end

        def slot_config_shale_xml_mapper_declarations(indent: 10)
          build_declarations(indent:) do |decl|
            slots.each do |slot|
              decl << slot.to_shale_xml_mapper_declaration
            end
          end
        end
      end

      refine ::TemplateProperty do
        def model_sort_key
          if any_enum?
            1
          elsif ordering_definition?
            2
          else
            9
          end
        end

        def has_model_declaration?
          model_sort_key.present?
        end

        def to_model_declaration
          if any_enum? && !skip_declaration?
            to_pg_enum_declaration
          elsif ordering_definition?
            to_ordering_definition_declaration
          end
        end

        def to_ordering_definition_declaration
          %[attribute #{name.to_sym.inspect}, ::Schemas::Orderings::Definition.to_type]
        end

        def to_pg_enum_declaration
          parts = [
            "pg_enum! ",
            name.to_sym.inspect,
            ", as: ",
            enum_property.name.to_sym.inspect,
            ", allow_blank: false",
            ", suffix: ",
            name.to_sym.inspect,
          ]

          if enum_property.default.present?
            parts << ", default: " << enum_property.default.inspect
          end

          parts.join
        end

        def to_shale_attribute_declaration
          [].tap do |x|
            x << %[attribute #{name.to_sym.inspect}, ::#{shale_mapper_type_klass_name}]

            if has_default?
              x << %[, default: -> { #{default.inspect} }]
            end
          end.join
        end

        def to_shale_xml_mapper_declaration
          <<~RUBY.strip_heredoc.strip
          map_element #{shale_mapper_element}, to: #{name.to_sym.inspect}
          RUBY
        end

        def shale_mapper_element
          name.dasherize.inspect
        end
      end

      refine ::TemplateSlot do
        def to_shale_attribute_declaration
          [].tap do |x|
            x << %[attribute #{name.to_sym.inspect}, ::Templates::Config::Utility::SlotValue]

            if has_default?
              x << %[, default: -> { ::TemplateSlot.default_slot_value_for(#{id.inspect}) }]
            end
          end.join
        end

        def to_shale_xml_mapper_declaration
          <<~RUBY.strip_heredoc.strip
          map_element #{shale_mapper_element}, to: #{name.to_sym.inspect}, render_nil: true
          RUBY
        end

        def shale_mapper_element
          name.dasherize.inspect
        end
      end
    end
  end
end
