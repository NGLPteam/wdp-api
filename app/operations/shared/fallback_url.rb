# frozen_string_literal: true

module Shared
  # @todo Add fallback logic for preview images stored in a bucket.
  class FallbackUrl
    extend Dry::Core::Cache

    # include WDPAPI::Deps[bucket: "shared.bucket"]

    # @param [#to_s] derivative_name
    # @param [:png, :webp] format
    # @return [String, nil]
    def call(derivative_name, format: :png)
      return nil

      # fetch_or_store(derivative_name.to_s, format.to_s) do
      #   bucket.object("fallback/#{derivative_name}.#{format}")&.public_url
      # end
    end
  end
end
