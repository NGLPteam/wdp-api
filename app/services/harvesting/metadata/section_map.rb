# frozen_string_literal: true

module Harvesting
  module Metadata
    # A mapping that stores {Harvesting::Metadata::WrappedXMLExtractor} by their `wrapper_id`
    class SectionMap
      include Dry::Core::Equalizer.new(:parent, :name, :keys)
      include Enumerable
      include Dry::Initializer[undefined: false].define -> do
        param :parent, Harvesting::Types.Instance(Harvesting::Metadata::BaseXMLExtractor)
        param :name, Harvesting::Types::Coercible::String
        param :children, Harvesting::Types::Array.of(Harvesting::Types.Instance(Harvesting::Metadata::WrappedXMLExtractor))

        option :key_attribute, Harvesting::Types::Symbol, default: proc { :section_id }
      end
      include Shared::Typing

      # @return [<String>]
      attr_reader :keys

      delegate :empty?, :length, :size, to: :children

      def initialize(*)
        super

        @mapping = {}
        @keys = []

        children.each do |child|
          child.section_map = self

          key = child.public_send key_attribute

          @mapping[key] = child
          @keys << key
        end

        @mapping.freeze
        @keys.freeze

        freeze
      end

      # @param [String] wrapper_id
      # @return [Harvesting::Metadata::Section, nil]
      def [](wrapper_id)
        @mapping[wrapper_id]
      end

      # @see Hash#fetch
      # @return [Harvesting::Metadata::Section]
      def fetch(...)
        @mapping.fetch(...)
      end

      # @yieldparam [Harvesting::Metadata::WrappedXMLExtractor]
      # @yieldreturn [void]
      # @return [void]
      def each
        return enum_for(__method__) unless block_given?

        children.each do |child|
          yield child
        end
      end

      # Build a filtered section map based on a predicate applied to its sections.
      # @return [Harvesting::Metadata::SectionMap]
      def funnel(&block)
        new_children = select(&block)

        self.class.new(parent, name, new_children, key_attribute: key_attribute)
      end

      # @param [#to_sym] tags
      # @return [Harvesting::Metadata::SectionMap]
      def tagged_with(*tags)
        tags = Harvesting::Types::SectionTags[tags.flatten]

        funnel do |section|
          tags.any? do |tag|
            section.tagged_with? tag
          end
        end
      end

      class << self
        # Build a map iteratively, ensuring sections are unique.
        #
        # @yield [builder] Sections should be compiled within this block.
        # @yieldparam [Harvesting::Metadata::SectionMap::Builder] builder
        # @yieldreturn [void]
        # @return [Harvesting::Metadata::SectionMap]
        def build_for(...)
          builder = Builder.new(...)

          yield builder if block_given?

          builder.__send__ :to_map
        end
      end

      # @api private
      #
      # A simple class used to validate and build {Harvesting::Metadata::SectionMap}
      class Builder
        include Dry::Initializer[undefined: false].define -> do
          param :parent, Harvesting::Types.Instance(Harvesting::Metadata::BaseXMLExtractor)
          param :name, Harvesting::Types::Coercible::String

          option :key_attribute, Harvesting::Types::Symbol, default: proc { :section_id }
        end

        def initialize(*)
          super

          @matcher = Harvesting::Types::MetadataSection.constrained(respond_to: key_attribute)

          @mapping = {}
        end

        # @param [Harvesting::Metadata::Section] child
        # @return [self]
        def <<(child)
          child = @matcher[child]

          key = child.public_send key_attribute

          raise AlreadyDefinedSection, "Already defined #{name} section:#{key}" if @mapping.key?(key)

          @mapping[key] = child

          return self
        end

        private

        # @return [Harvesting::Metadata::SectionMap]
        def to_map
          children = @mapping.values

          Harvesting::Metadata::SectionMap.new(
            parent,
            name,
            children,
            key_attribute: key_attribute
          )
        end
      end

      # An error that gets raised when trying to define a section
      # with the same ID multiple times. It points to invalid or
      # unexpected XML structures that we need to handle.
      class AlreadyDefinedSection < KeyError; end
    end
  end
end
