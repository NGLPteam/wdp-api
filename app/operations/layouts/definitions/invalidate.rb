# frozen_string_literal: true

module Layouts
  module Definitions
    # @see Layouts::Definitions::Invalidator
    class Invalidate < Support::SimpleServiceOperation
      service_klass Layouts::Definitions::Invalidator
    end
  end
end
