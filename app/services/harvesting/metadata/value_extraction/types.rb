# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # Types specifically used for extracting values.
      module Types
        include Dry.Types

        # Try to parse a `Date`, making sure `DateTime` is coerced.
        ExtractedDate = JSON::Date.constructor do |value|
          case value
          when ::DateTime then value.to_date
          else
            value
          end
        end

        # An instance of {Harvesting::Metadata::ValueExtraction::Struct}.
        ExtractedValues = Harvesting::Metadata::ValueExtraction::Struct::Type

        # A list of {ExtractedValues}
        ExtractedValueList = Harvesting::Metadata::ValueExtraction::Struct::List

        # A hash of {ExtractedValues}.
        ExtractedValueMap = Harvesting::Metadata::ValueExtraction::Struct::Map

        # We're dealing with a lot of XML so let's just go ahead and coerce it to string
        # when we are expecting a string.
        MaybeXMLText = Coercible::String.constructor do |value|
          case value
          when Nokogiri::XML::Node then value.text
          else
            value
          end
        end

        # @see MaybeXMLText
        MaybeXMLInteger = Coercible::Integer.constructor do |value|
          case value
          when Nokogiri::XML::Node, Nokogiri::XML::NodeSet then value.text
          else
            value
          end
        end

        # Enforce a string that is not `blank?`.
        PresentString = MaybeXMLText.constrained(present: true)

        # An HTTP (or HTTPS) URL.
        URL = Coercible::String.constrained(http_uri: true)

        # @api private
        Registry = Dry::Schema::TypeContainer.new

        # @api private
        NS = (%w[coercible nominal json params] + [nil]).freeze

        # @api private
        EXTRA = {
          contributions: Coercible::Array.of(Hash).fallback { [] },
          contribution_proxy: Harvesting::Contributions::Proxy::Type,
          contribution_proxies: Harvesting::Contributions::Proxy::List,
          extracted_date: ExtractedDate,
          extracted_values: ExtractedValues,
          extracted_value_list: ExtractedValueList,
          extracted_value_map: ExtractedValueMap,
          full_text: FullText::Types::NormalizedReference,
          journal_source: Instance(Harvesting::Utility::ParsedJournalSource),
          present_string: PresentString,
          string_list: Coercible::Array.of(PresentString),
          url: URL,
          variable_precision_date: Instance(::VariablePrecisionDate)
        }.freeze

        NS.product(EXTRA.to_a).each do |(ns, (key, type))|
          path = [ns, key].compact.join(?.)

          Registry.register path, type
        end

        # @api private
        TYPE_KEYS = Registry.keys.freeze

        # @api private
        TypeName = Coercible::String.enum(*TYPE_KEYS)

        # @api private
        #
        # An enum type that matches the name of any default `dry-types` Params type.
        PossibleParamTypeName = TYPE_KEYS.grep(/\Aparams\./).then do |types|
          unprefixed_types = types.map { |type| type.sub(/\Aparams\./, "") }

          Coercible::String.enum(*unprefixed_types)
        end

        # A constructor type that either takes a `Dry::Types::Type` directly,
        # or arbitrary string/symbol input and tries to figure out the right
        # type to use for that name. We use it to keep value extraction
        # simpler without having to do a lot of `Types::Foo`.
        Type = Nominal(Dry::Types::Type).constructor do |value|
          case value
          when :any then Any
          when :boolean then Params::Bool
          when :string then MaybeXMLText
          when :integer then MaybeXMLInteger
          when :contributor_name then ::Contributors::Types::AnyName
          when Dry::Types::Type then value
          when PossibleParamTypeName then Registry["params.#{value}"]
          when TypeName then Registry[value]
          else
            # :nocov:
            value
            # :nocov:
          end
        end.constrained(type: Dry::Types::Type)
      end
    end
  end
end
