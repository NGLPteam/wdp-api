# frozen_string_literal: true

module Entities
  # @see Entities::Purger
  class Purge < Support::SimpleServiceOperation
    service_klass Entities::Purger
  end
end
