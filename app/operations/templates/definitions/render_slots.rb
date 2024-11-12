# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::SlotsRenderer
    class RenderSlots < Support::SimpleServiceOperation
      service_klass Templates::Definitions::SlotsRenderer
    end
  end
end
