# frozen_string_literal: true

module FullText
  class ParseMarkdown
    include Dry::Monads[:result]

    RENDERER = Redcarpet::Render::HTML.new(
      filter_html: false,
    )

    MARKDOWN = Redcarpet::Markdown.new(
      RENDERER,
      no_intra_emphasis: true,
      tables: false,
      fenced_code_blocks: true,
      disable_indented_code_blocks: false,
      lax_spacing: false,
      quote: false,
      superscript: false,
    )

    def call(content)
      rendered = MARKDOWN.render(content)

      Success(rendered)
    end
  end
end
