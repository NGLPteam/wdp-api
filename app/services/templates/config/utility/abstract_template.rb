# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # @abstract
      class AbstractTemplate < Shale::Mapper
        extend DefinesMonadicOperation
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants
        include Dry::Core::Memoizable
        include Mappers::BetterXMLPrinting

        # @see Templates::Config::ApplyTemplate
        # @see Templates::Config::TemplateApplicator
        # @param [LayoutDefinition] layout_definition
        # @return [Dry::Monads::Success(TemplateDefinition)]
        monadic_operation! def apply_to(layout_definition, **options)
          MeruAPI::Container["templates.config.apply_template"].(self, layout_definition, **options)
        end

        # @return [Ox::Element]
        def to_ox_element
          Ox.load(to_xml)
        end

        # @return [{ Symbol => Object }]
        def to_template_definition_attrs
          props = to_template_definition_props
          slots = to_template_definition_slots

          { **props, slots: }
        end

        # @return [{ Symbol => Object }]
        def to_template_definition_props
          template_record.property_names_for_configuration.index_with { to_template_definition_property_value(_1) }.symbolize_keys
        end

        # @see Templates::Config::Utility::AbstractTemplateSlots#to_template_definition_slots
        # @return [{ Symbol => { :raw_template => String }}]
        def to_template_definition_slots
          slots.to_template_definition_slots
        end

        # @api private
        # @param [Templates::Types::PropertyName] name
        # @return [Object]
        def to_template_definition_property_value(name)
          raw_value = __send__(name)

          case raw_value
          when ::Templates::Config::Properties::OrderingDefinition
            raw_value.to_definition(template_kind:)
          else
            raw_value.as_json
          end
        end

        class << self
          def inherited(klass)
            klass.include ::Templates::Config::ConfiguresTemplate

            super

            # This needs to be defined after inheritance, because otherwise it
            # messes up XML serialization and will _always_ be included as a tag.
            klass.attribute :position, Shale::Type::Integer, default: -> { 1 }
          end

          # @return [String]
          def xml_root
            xml_mapping.unprefixed_root
          end
        end
      end
    end
  end
end
