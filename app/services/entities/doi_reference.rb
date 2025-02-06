# frozen_string_literal: true

module Entities
  class DOIReference < Support::FlexibleStruct
    DOMAIN = Entities::Types::DOI_DOMAIN

    attribute :doi, Entities::Types::DOI

    attribute? :host, Entities::Types::String.default(DOMAIN)

    alias label doi

    # @see Templates::MDX::BuildAnchor
    # @return [ActiveSupport::SafeBuffer]
    attr_reader :link

    # @return [String]
    attr_reader :url

    alias href url

    def initialize(...)
      super

      @url = URI.join("https://#{host}", doi).to_s

      @link = MeruAPI::Container["templates.mdx.build_anchor"].(href:, label:).value!
    end

    # @return [Entities::DOIData]
    def to_doi_data
      crossref = host == DOMAIN

      Entities::DOIData.new(crossref:, doi:, url:, host:, ok: true)
    end
  end
end
