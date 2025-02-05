# frozen_string_literal: true

module Entities
  class DOIReference < Support::FlexibleStruct
    DOMAIN = Entities::Types::DOI_DOMAIN

    attribute :doi, Entities::Types::DOI

    alias label doi

    # @see Templates::MDX::BuildAnchor
    # @return [ActiveSupport::SafeBuffer]
    attr_reader :link

    # @return [String]
    attr_reader :url

    alias href url

    def initialize(...)
      super

      @url = URI.join("https://#{DOMAIN}", doi).to_s

      @link = MeruAPI::Container["templates.mdx.build_anchor"].(href:, label:).value!
    end
  end
end
