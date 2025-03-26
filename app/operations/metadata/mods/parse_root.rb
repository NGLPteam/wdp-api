# frozen_string_literal: true

module Metadata
  module MODS
    # @see Metadata::MODS::RootParser
    class ParseRoot < Support::SimpleServiceOperation
      service_klass Metadata::MODS::RootParser
    end
  end
end
