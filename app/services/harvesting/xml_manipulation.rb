# frozen_string_literal: true

module Harvesting
  # Methods that allow an object to manipulate XML trees in a stack-based approach
  module XMLManipulation
    extend ActiveSupport::Concern
    extend Shared::Typing

    include Stacks::Parent

    included do
      extend Dry::Core::ClassAttributes

      # @!scope class
      # @!attribute [r] namespaces
      # @see .add_namespace!
      # @see .namespaces!
      # @return [Harvesting::Types::XMLNamespaceMap]
      defines :namespaces, type: Harvesting::Types::XMLNamespaceMap

      namespaces Hash.new

      define_stack! :element, coercer: :enforce_element, default: :default_element
      define_stack! :namespaces, coercer: :merge_namespaces, default: :default_namespaces

      alias_method :with_ns, :with_namespaces
      alias_method :namespaces, :current_namespaces
    end

    # @!group Stack Methods

    # @abstract
    # @note The default value for {#namespaces_stack}.
    # @return [Harvesting::Types::XMLNamespaceMap]
    def default_namespaces
      self.class.namespaces
    end

    # @param [Nokogiri::XML::Node, nil] element
    # @return [Nokogiri::XML::Element, Utility::NullXMLElement]
    def enforce_element(element)
      element || null_element
    end

    # @abstract
    # @note The default value for {#element_stack}
    # @return [Nokogiri::XML::Element, Utility::NullXMLElement]
    def default_element
      null_element
    end

    # @api private
    # @param [{ Symbol > String }]
    # @return [{ Symbol => String }]
    def merge_namespaces(additional = {}, **other)
      additional.merge!(other)

      return namespaces if additional.blank?

      additional = Harvesting::Types::XMLNamespaceMap[additional]

      namespaces.merge(additional)
    end

    # @!endgroup

    # @param [String] query XPath query
    # @param [Nokogiri::XML::Element, #xpath, nil] element
    # @return [Nokogiri::XML::Element, Utility::NullXMLElement]
    def at_xpath(query, **additional, &)
      with_ns additional do
        current_element.at_xpath(query, **current_namespaces).tap do |result|
          with_element(result, &) if block_given?
        end
      end
    end

    # @param [String] query XPath query
    # @param [Nokogiri::XML::Element, #xpath, nil] element
    # @return [Nokogiri::XML::NodeSet]
    def xpath(query, **additional, &)
      with_ns additional do
        current_element.xpath(query, **current_namespaces).tap do |node_set|
          node_set.each do |element|
            with_element(element, &)
          end if block_given?
        end
      end
    end

    # @see #xpath
    # @param [#xpath, nil] element
    # @param [String] query
    # @return [Nokogiri::XML::NodeSet, nil]
    def all_from(element, query)
      with_element element do
        xpath query
      end
    end

    # @param [<String>] paths
    # @param [String, nil] fallback
    # @return [String, nil]
    def find_candidate_text_at(paths, fallback: nil)
      Array(paths).each do |path|
        value = at_xpath(path).text

        return value if value.present?
      end

      return fallback
    end

    # @param [#at_xpath] element
    # @param [<String>] paths
    # @param [String, nil] fallback
    # @return [String, nil]
    def find_candidate_text_for(element, paths, fallback: nil)
      with_element element do
        find_candidate_text_at(paths, fallback:)
      end
    end

    # @see #at_xpath
    # @param [#at_xpath, nil] element
    # @param [String] xpath
    # @return [Nokogiri::XML::Element, nil]
    def from(element, query)
      with_element element do
        at_xpath query
      end
    end

    # @api private
    # @param [Nokogiri::XML::Element, nil] element
    # @param [Integer, nil] fallback
    # @return [Integer, nil]
    def int_from(element, fallback: nil)
      element&.text&.to_i || fallback
    end

    # @abstract
    # @return [Utility::NullXMLElement]
    def null_element
      # :nocov:
      ::Utility::NullXMLElement.new
      # :nocov:
    end

    # @api private
    # @param [Nokogiri::XML::Element, nil] element
    # @param [String, nil] fallback
    # @return [String, nil]
    def text_from(element, fallback: nil)
      element&.text&.strip || fallback
    end

    class_methods do
      def default_namespace!(url)
        add_namespace! :xmlns, url
      end

      # @return [void]
      def add_namespace!(name, url)
        namespaces! name => url
      end

      # @return [void]
      def namespaces!(new_namespaces = {}, **symbol_namespaces)
        new_namespaces.merge!(symbol_namespaces)

        merged = namespaces.merge Harvesting::Types::XMLNamespaceMap[new_namespaces]

        namespaces merged
      end

      def add_xlink!
        add_namespace! :xlink, Metadata::Namespaces[:xlink]
      end

      def add_xsi!
        add_namespace! :xsi, Metadata::Namespaces[:xsi]
      end
    end
  end
end
