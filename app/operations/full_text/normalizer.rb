# frozen_string_literal: true

module FullText
  # Normalize a value for a full-text property and turn it into a hash that matches {AppTypes::FullTextReference}.
  #
  # @see SchematicText
  class Normalizer
    # This method can turn a string, existing {SchematicText}, or hash into
    # a properly-formatted, symbol-keyed full-text reference, containing
    # the content, the language, and the content-type (falling back to text
    # if unspecified). It will _always_ return a `Hash`, regardless of input.
    #
    # @param [Hash, SchematicText, String] value
    # @return [{ Symbol => Object }] (@see AppTypes::FullTextReference)
    def call(value)
      case value
      when ::SchematicText
        value.to_reference
      when String
        { content: value, lang: nil, kind: "text" }
      when AppTypes::FullTextReference
        AppTypes::FullTextReference[value]
      else
        { content: nil, lang: nil, kind: "text" }
      end.tap do |h|
        h[:content] ||= ""
        h[:lang] ||= ""
      end
    end
  end
end
