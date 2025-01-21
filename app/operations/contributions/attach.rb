# frozen_string_literal: true

module Contributions
  # @see Contributions::Attacher
  class Attach < Support::SimpleServiceOperation
    service_klass Contributions::Attacher
  end
end
