# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::ManualListMaintainer
    class MaintainManualList < Support::SimpleServiceOperation
      service_klass Templates::Definitions::ManualListMaintainer
    end
  end
end
