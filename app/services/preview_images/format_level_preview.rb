# frozen_string_literal: true

module PreviewImages
  class FormatLevelPreview
    extend Dry::Initializer

    include PreviewImages::SharedConstants

    param :style_level, AppTypes.Instance(PreviewImages::StyleLevelPreview)
    param :format_name, FormatName
    param :uploaded_file, UploadedFile.optional, optional: true

    delegate :dimensions, :height, :width, to: :style_level, prefix: :default
    delegate :dimensions, :height, :width, to: :uploaded_file, prefix: :exact, allow_nil: true
    delegate :style_name, :top_level, to: :style_level
    delegate :alt, :top_level_url, to: :top_level

    def dimensions
      exact_dimensions || default_dimensions
    end

    def height
      exact_height || default_height
    end

    def width
      exact_width || default_width
    end

    def url(**url_options)
      if uploaded_file.present?
        uploaded_file.url(url_options)
      else
        top_level_url(style_name, format_name, url_options)
      end
    end

    # @return [String]
    def original_filename
      "#{style_name}.#{format_name}"
    end
  end
end
