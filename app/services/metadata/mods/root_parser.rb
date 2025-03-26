# frozen_string_literal: true

module Metadata
  module MODS
    # @see Metadata::MODS::ParseRoot
    class RootParser < ::Metadata::Shared::AbstractXMLRootParser
      enforced_namespace! "mods", "http://www.loc.gov/mods/v3"

      root_klass ::Metadata::MODS::Root
    end
  end
end
