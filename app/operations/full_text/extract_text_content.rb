# frozen_string_literal: true

module FullText
  # An operation for extracting the raw text of full-text content.
  #
  # @see #call
  class ExtractTextContent
    # Extract the actual text of provided full-text content based
    # on the provided content type.
    #
    # @param ["html", "markdown", "text"] kind
    # @param [String] content
    # @return [String, nil]
    def call(kind:, content:, **)
      case kind
      when "html"
        parse_html content
      when "markdown"
        parse_markdown content
      when "text"
        content
      end.then do |text_content|
        text_content.squish.strip if text_content.kind_of?(String) && text_content.present?
      end
    end

    private

    # Parse HTML content with `Nokogiri` and extract the text.
    #
    # @param [String] content
    # @return [String]
    def parse_html(content)
      return nil if content.blank?

      Nokogiri::HTML(content).text
    end

    # Parse markdown content with `Kramdown` and extract the text
    # from the generated HTML.
    #
    # @param [String] content
    # @return [String]
    def parse_markdown(content)
      return nil if content.blank?

      doc = Kramdown::Document.new content

      html = Nokogiri::HTML.fragment doc.to_html

      html.text
    end
  end
end
