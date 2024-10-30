# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::DynamicResolver
    class ResolveDynamic < Support::SimpleServiceOperation
      service_klass Schemas::Orderings::DynamicResolver
    end
  end
end
