# frozen_string_literal: true

module Contributors
  module SharedRules
    extend ActiveSupport::Concern

    included do
      rule(:email).validate(:maybe_email_format)

      rule(:url).validate(:maybe_url_format)

      rule(:links).each do |index:|
        key([:links, index, :url]).failure(:must_be_url) unless URI::DEFAULT_PARSER.make_regexp(%w[http https]).match?(value[:url])
      end

      rule(:clear_image, :image) do
        key(:clear_image).failure("cannot be set while uploading a new image") if key?(:clear_image) && key?(:image) && values[:image].present?
      end
    end
  end
end
