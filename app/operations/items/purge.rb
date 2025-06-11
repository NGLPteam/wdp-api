# frozen_string_literal: true

module Items
  # @see Items::Purger
  class Purge < Support::SimpleServiceOperation
    service_klass Items::Purger
  end
end
