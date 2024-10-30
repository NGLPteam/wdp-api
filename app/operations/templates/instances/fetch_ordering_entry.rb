# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::OrderingEntryFetcher
    class FetchOrderingEntry < Support::SimpleServiceOperation
      service_klass Templates::Instances::OrderingEntryFetcher
    end
  end
end
