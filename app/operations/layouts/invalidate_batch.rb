# frozen_string_literal: true

module Layouts
  # @see Layouts::BatchInvalidator
  class InvalidateBatch < Support::SimpleServiceOperation
    service_klass Layouts::BatchInvalidator
  end
end
