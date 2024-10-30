# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::SelectionSourceResolver
    class ResolveSelectionSource < Support::SimpleServiceOperation
      service_klass Templates::Definitions::SelectionSourceResolver
    end
  end
end
