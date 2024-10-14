# frozen_string_literal: true

module Templates
  module Slots
    # @see Templates::Slots::Renderer
    class Render < Support::SimpleServiceOperation
      service_klass Templates::Slots::Renderer
    end
  end
end
