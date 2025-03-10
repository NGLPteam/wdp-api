# frozen_string_literal: true

module Harvesting
  module Protocols
    module Unknown
      # The unknown protocol context does nothing.
      class Context < Harvesting::Protocols::Context
        def perform_check!
          # The unknown protocol is always inactive.
          check_failed
        end
      end
    end
  end
end
