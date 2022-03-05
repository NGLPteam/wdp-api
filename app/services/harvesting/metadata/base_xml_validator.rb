# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class BaseXMLValidator
      extend Dry::Core::ClassAttributes

      include Dry::Monads[:result, :list, :validated, :do]
      include Harvesting::ParsesXML

      defines :required_namespaces, type: Harvesting::Types::XMLNamespaceMap

      required_namespaces Hash.new

      defines :root_tag

      delegate :required_namespaces, :root_tag, to: :class

      # Validate the XML based on class-declared validations and optionally {#transform} it.
      #
      # @param [String] raw_xml
      # @return (@see #transform)
      # @return [Dry::Monads::Success(String)] re-compiled XML to be persisted in the database
      # @return [Dry::Monads::Failure]
      def call(raw_xml)
        doc = xml_parser.call raw_xml

        yield validate! doc

        yield augment!(doc)

        Success doc.to_xml
      end

      # @note The return value of this method is ignored, unless we want to override it
      #   and raise a failure because the augmentation failed in some way.
      # @abstract An optional hook for making in-place modifications to the validated XML.
      # @param [Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment] doc
      # @return [Dry::Monads::Success(void)]
      def augment!(doc)
        Success()
      end

      # A hook for handling transformations on the validated XML.
      #
      # @return [Dry::Monads::Success(String)] re-compiled XML to be persisted in the database
      # @return [Dry::Monads::Failure]
      def transform(string)
        Success doc.to_xml
      end

      private

      # @param [Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment] doc
      # @return [Dry::Monads::Result]
      def validate!(doc)
        validations = build_validations doc

        List::Validated.coerce(validations).traverse.to_result
      end

      # @param [Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment] doc
      # @return [<Dry::Monads::Validated>]
      def build_validations(doc)
        [].tap do |arr|
          self.class.required_namespaces.each do |ns, value|
            arr << enforce_namespace(doc, ns, value)
          end

          arr << enforce_root_tag(doc)
        end
      end

      # @param [Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment] doc
      # @return [Dry::Monads::Validated]
      def enforce_root_tag(doc)
        return valid! if root_tag.blank?

        return invalid!(:root_tag, :fragment, name: root_tag) if doc.fragment?

        actual = doc.root&.name

        return valid! if root_tag == actual

        invalid!(:root_tag, :mismatch, name: root_tag, actual: actual)
      end

      # @param [Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment] doc
      # @param [#to_s] namespace
      # @param [String] expected
      # @return [Dry::Monads::Validated]
      def enforce_namespace(doc, namespace, expected)
        actual = doc.namespaces[namespace.to_s]

        return valid! if actual == expected

        options = {
          expected: expected,
          namespace: namespace.to_s,
          actual: actual.presence,
        }.compact.transform_values(&:inspect)

        reason = actual.present? ? :invalid : :missing

        invalid! :namespace, reason, options
      end

      def valid!
        Success().to_validated
      end

      def invalid!(key, reason, **options)
        message = failure_message_for key, reason, options

        Failure[key, message].to_validated
      end

      def failure_message_for(key, reason, **options)
        opts = {
          **options,
          scope: [:xml_validation, key],
        }

        I18n.t reason, opts
      end

      class << self
        # @param [String] value
        # @return [void]
        def default_namespace!(value)
          required_namespace! :xmlns, value
        end

        # @param [#to_sym] name
        # @param [String] value
        # @return [void]
        def required_namespace!(name, value)
          required_namespaces! name => value
        end

        # @param [{ #to_sym => String, Symbol }] new_ns
        # @return [void]
        def required_namespaces!(new_ns = {})
          new_ns = Harvesting::Types::XMLNamespaceMap[new_ns]

          merged = required_namespaces.merge new_ns

          required_namespaces merged
        end
      end
    end
  end
end
