# frozen_string_literal: true

module Collections
  # @see Collections::Purger
  class Purge < Support::SimpleServiceOperation
    service_klass Collections::Purger
  end
end
