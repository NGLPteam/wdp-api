# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::EntityListFetcher
    class FetchEntityList < Support::SimpleServiceOperation
      service_klass Templates::Instances::EntityListFetcher
    end
  end
end
