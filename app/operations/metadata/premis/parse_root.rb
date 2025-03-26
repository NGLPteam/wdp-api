# frozen_string_literal: true

module Metadata
  module PREMIS
    # @see Metadata::PREMIS::RootParser
    class ParseRoot < Support::SimpleServiceOperation
      service_klass Metadata::PREMIS::RootParser
    end
  end
end
