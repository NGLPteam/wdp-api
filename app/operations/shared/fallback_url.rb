# frozen_string_literal: true

module Shared
  class FallbackURL
    include PreviewImages::SharedConstants

    # @param [#to_s] derivative_name
    # @param [:png, :webp] format
    # @return [String, nil]
    def call(derivative_name, format: :png, attachment_name: nil)
      uri = "/images/#{StyleName[derivative_name]}.#{FormatName[format]}"

      URI.join(LocationsConfig.api, uri).to_s
    end
  end
end
