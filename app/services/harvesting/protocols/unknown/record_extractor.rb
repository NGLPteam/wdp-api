# frozen_string_literal: true

module Harvesting
  module Protocols
    module Unknown
      class RecordExtractor < Harvesting::Protocols::RecordExtractor
        def extract(identifier)
          # :nocov:
          Failure[:unsupported]
          # :nocov:
        end
      end
    end
  end
end
