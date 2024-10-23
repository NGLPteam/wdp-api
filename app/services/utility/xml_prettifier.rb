# frozen_string_literal: true

module Utility
  # Text nodes that contain newlines end up looking really
  # bad with the default prettification available in Nokogiri, Ox, etc.
  #
  # This service remedies that.
  class XMLPrettifier < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :raw_xml, Support::Types::String
    end

    CONTAINS_NEWLINES = /\w.*\n.*\w/

    standard_execution!

    # @return [Nokogiri::XML::Document]
    attr_reader :doc

    # @return [String]
    def call
      run_callbacks :execute do
        yield prepare!

        yield pretty_indent_text!
      end

      return doc.to_xml
    end

    wrapped_hook! def prepare
      @doc = Nokogiri::XML(raw_xml)

      super
    end

    wrapped_hook! def pretty_indent_text
      doc.xpath("//text()").each do |node|
        next if skip_text?(node)

        adjust_text_node! node
      end

      super
    end

    private

    # @param [String] content
    # @param [Integer] depth
    # @param [Integer] final
    # @return [String]
    def adjust_text_content(content, depth: 1, final: 0)
      "\n#{content.indent(depth * 2)}\n" + ("  " * final)
    end

    # @param [Nokogiri::XML::Text] node
    # @return [void]
    def adjust_text_node!(node)
      depth = node.ancestors.size - 1

      final = (depth - 1).clamp(0, depth)

      node.content = adjust_text_content(node.content, depth:, final:)
    end

    # @param [Nokogiri::XML::Text] node
    def skip_text?(node)
      node.cdata? || skip_content?(node.content)
    end

    def skip_content?(content)
      content.blank? || CONTAINS_NEWLINES !~ content
    end
  end
end
