# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      module OAIDC
        # This just uses the default format provided by oai-pmh gem.
        # We may overwrite it.
        class Format < ::OAI::Provider::Metadata::DublinCore
        end
      end
    end
  end
end
