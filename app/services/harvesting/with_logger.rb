# frozen_string_literal: true

module Harvesting
  module WithLogger
    extend ActiveSupport::Concern

    included do
      include Dry::Effects.Resolve(:logger)
    end

    # @return [void]
    def log(...)
      logger.log(...)
    end
  end
end
