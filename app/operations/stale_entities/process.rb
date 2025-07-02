# frozen_string_literal: true

module StaleEntities
  # @see StaleEntities::Processor
  class Process < Support::SimpleServiceOperation
    service_klass StaleEntities::Processor
  end
end
