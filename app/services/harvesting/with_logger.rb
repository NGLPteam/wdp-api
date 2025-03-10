# frozen_string_literal: true

module Harvesting
  module WithLogger
    extend ActiveSupport::Concern

    COMMON_LOGGER = Harvesting::Logs::Logger.new

    included do
      include Dry::Effects.Reader(:logger, default: COMMON_LOGGER)
    end

    # @return [void]
    def log(...)
      logger.log(...)
    end
  end
end
