# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      module JATS
        class Format < ::OAI::Provider::Metadata::Format
          def initialize
            @prefix = "jats"
            @schema = "https://jats.nlm.nih.gov/publishing/0.4/xsd/JATS-journalpublishing0.xsd"
            @namespace = "http://jats.nlm.nih.gov"
            @element_namespace = ""
            @fields = []
          end

          def header_specification
            {}
          end
        end
      end
    end
  end
end
