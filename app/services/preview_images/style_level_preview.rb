# frozen_string_literal: true

module PreviewImages
  class StyleLevelPreview
    extend Dry::Initializer

    include PreviewImages::SharedConstants

    param :top_level, AppTypes.Instance(PreviewImages::TopLevelPreview)
    param :style_name, StyleName

    delegate :alt, :attacher, :top_level_url, to: :top_level
    delegate :derivatives, to: :attacher

    def dimensions
      @dimensions ||= DIMENSIONS.fetch(style_name.to_sym)
    end

    def height
      dimensions.second
    end

    def width
      dimensions.first
    end

    def png
      format_level_preview :png
    end

    def webp
      format_level_preview :webp
    end

    private

    def formats
      @formats ||= Hash(attacher.get(style_name))
    end

    def format_level_preview(format_name)
      FormatLevelPreview.new self, format_name, attacher.get(style_name, format_name)
    end
  end
end
