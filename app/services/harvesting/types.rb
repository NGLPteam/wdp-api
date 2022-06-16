# frozen_string_literal: true

module Harvesting
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    VALID_NAME = /\A([a-z_][a-zA-Z_0-9]*)\z/.freeze

    VALID_PATH = /\A(?<part>[a-z_][a-zA-Z_0-9]*)\.\g<part>\z/.freeze

    # @see ::HarvestAttempt
    Attempt = Instance(::HarvestAttempt)

    Callable = Interface(:call)

    # Something that enforces an always-default hash
    EmptyDefaultHash = Coercible::Hash.default { {} }.fallback { {} }

    # @see ::HarvestEntity
    Entity = Instance(::HarvestEntity)

    # A simple pass-through identity function
    Identity = proc { _1 }

    Identifier = Coercible::Symbol.constrained(format: VALID_NAME)

    Identifiers = Array.of(Identifier)

    Mapping = Instance(::HarvestMapping)

    MaxRecordCount = Integer.constrained(gt: 0, lteq: Harvesting::ABSOLUTE_MAX_RECORD_COUNT).
      default(Harvesting::ABSOLUTE_MAX_RECORD_COUNT).
      fallback(Harvesting::ABSOLUTE_MAX_RECORD_COUNT)

    MetadataFormat = Coercible::String.enum("jats", "mets", "mods")

    # @see Harvesting::Metadata::Section
    MetadataSection = Instance(Harvesting::Metadata::Section)

    # @see MetadataSection
    MetadataSectionList = Array.of(MetadataSection)

    # @see Harvesting::Metadata::SectionParent
    MetadataSectionParent = Instance(Harvesting::Metadata::SectionParent)

    Path = Coercible::String.constrained(format: VALID_PATH) | Coercible::String.constrained(format: VALID_NAME)

    Paths = Coercible::Array.of(Path)

    ProtocolName = Coercible::String.enum("oai").fallback("oai")

    # @see ::HarvestRecord
    Record = Instance(::HarvestRecord)

    SectionTag = Coercible::Symbol

    SectionTags = Array.of(SectionTag)

    # @see ::HarvestSet
    Set = Instance(::HarvestSet)

    # @see ::HarvestSource
    Source = Instance(::HarvestSource)

    # @see ::HarvestTarget
    Target = Instance(::HarvestTarget)

    # Any dry type
    Type = Instance(Dry::Types::Type)

    # An XML document, ideally well-formed
    XMLDocument = Instance Nokogiri::XML::Document

    # A single XML element
    XMLElement = Instance Nokogiri::XML::Element

    # An XML document fragment
    XMLFragment = Instance Nokogiri::XML::DocumentFragment

    # A magic string type that will try to look up provided values
    # in {Harvesting::Metadata::Namespaces}, otherwise it expects
    # any provided values to be strings. We do not make assumptions
    # that they have to be a URI.
    XMLNamespace = String.constructor do |value|
      Harvesting::Metadata::Namespaces.then do |container|
        container.key?(value) ? container[value] : value
      end
    end

    # A mapping of XML namespaces. It expects keys to be symbols (or strings coerced to symbols)
    # and values to be {XMLNamespace}.
    #
    # Once coerced, this can be provided as namespaces to Nokogiri's `at_xpath`, `xpath`, etc methods.
    XMLNamespaceMap = Hash.map(Coercible::Symbol.optional, XMLNamespace)

    # The actual method to use for parsing XML strings with Nokogiri.
    #
    # @see XMLParseType
    XMLParseMethod = Symbol.default(:parse).enum(:parse, :fragment).constructor do |value|
      value.to_s.gsub(/\Adocument\z/, "parse").to_sym.presence
    end

    # We might be parsing a document or a fragment.
    XMLParseType = Coercible::Symbol.default(:document).enum(:document, :fragment).fallback(:document)

    # A string of XML
    XMLString = Coercible::String

    # Any valid XML input for parsing.
    XMLInput = XMLDocument | XMLFragment | XMLString
  end
end
