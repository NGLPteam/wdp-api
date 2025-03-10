# frozen_string_literal: true

module Patches
  module CaptureXLinkHref
    class << self
      def prepended(klass)
        klass.attribute :href, :string

        klass.xml do
          map_attribute "href", to: :href, namespace: "http://www.w3.org/1999/xlink", prefix: :xlink
        end
      end
    end
  end
end

Niso::Jats::SelfUri.prepend Patches::CaptureXLinkHref
