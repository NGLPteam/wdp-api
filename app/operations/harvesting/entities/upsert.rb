# frozen_string_literal: true

module Harvesting
  module Entities
    # @see Harvesting::Entities::Upserter
    class Upsert < Support::SimpleServiceOperation
      service_klass Harvesting::Entities::Upserter
    end
  end
end
