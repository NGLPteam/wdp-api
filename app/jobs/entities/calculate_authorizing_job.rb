# frozen_string_literal: true

module Entities
  class CalculateAuthorizingJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      WDPAPI::Container["entities.calculate_authorizing"].call
    end
  end
end
