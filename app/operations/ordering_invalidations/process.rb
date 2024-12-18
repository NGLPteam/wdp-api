# frozen_string_literal: true

module OrderingInvalidations
  # @see OrderingInvalidations::Processor
  class Process < Support::SimpleServiceOperation
    service_klass OrderingInvalidations::Processor
  end
end
