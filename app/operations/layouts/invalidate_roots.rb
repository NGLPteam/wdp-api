# frozen_string_literal: true

module Layouts
  # @see Layouts::RootsInvalidator
  class InvalidateRoots < Support::SimpleServiceOperation
    service_klass Layouts::RootsInvalidator
  end
end
