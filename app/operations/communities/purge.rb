# frozen_string_literal: true

module Communities
  # @see Communities::Purger
  class Purge < Support::SimpleServiceOperation
    service_klass Communities::Purger
  end
end
