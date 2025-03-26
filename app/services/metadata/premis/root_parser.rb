# frozen_string_literal: true

module Metadata
  module PREMIS
    # @see Metadata::PREMIS::ParseRoot
    class RootParser < ::Metadata::Shared::AbstractXMLRootParser
      add_xsi!

      enforced_namespace! "premis", "http://www.loc.gov/premis/v3"

      root_klass ::Metadata::PREMIS::Root
    end
  end
end
