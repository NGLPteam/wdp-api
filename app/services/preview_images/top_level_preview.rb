# frozen_string_literal: true

module PreviewImages
  class TopLevelPreview
    extend Dry::Initializer

    include PreviewImages::SharedConstants

    param :attacher, AppTypes.Instance(PreviewUploader::Attacher)

    option :alt, AppTypes::String, default: proc { "preview image" }

    delegate :file, to: :attacher
    delegate :url, to: :attacher, prefix: :top_level

    STYLES.each do |style|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{style}                      # def thumb
        style_level #{style.inspect}    #   style_level :thumb
      end                               # end
      RUBY
    end

    private

    def style_level(style_name)
      StyleLevelPreview.new self, style_name
    end
  end
end
