# frozen_string_literal: true

module Harvesting
  module Protocols
    module Unknown
      # @api private
      class RecordProcessor < Harvesting::Protocols::RecordProcessor
        # @param [OAI::Record] oai_record
        def deleted?(_)
          # :nocov:
          true
          # :nocov:
        end

        def skip?(_)
          # :nocov:
          true
          # :nocov:
        end
      end
    end
  end
end
