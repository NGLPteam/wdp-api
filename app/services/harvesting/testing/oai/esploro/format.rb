# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      module Esploro
        class Format < ::OAI::Provider::Metadata::Format
          def initialize
            @prefix = "jats"
            @schema = "http://alma.exlibrisgroup.com/esploro/esploro_record.xsd"
            @namespace = "http://alma.exlibrisgroup.com/esploro"
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
