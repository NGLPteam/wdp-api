# frozen_string_literal: true

module Filtering
  class Run < Support::SimpleServiceOperation
    service_klass Filtering::Runner

    def rental_items(**options)
      call(RentalItem, options:)
    end
  end
end
