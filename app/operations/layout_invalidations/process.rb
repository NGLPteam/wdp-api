# frozen_string_literal: true

module LayoutInvalidations
  class Process < Support::SimpleServiceOperation
    service_klass LayoutInvalidations::Processor
  end
end
