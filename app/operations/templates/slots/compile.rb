# frozen_string_literal: true

module Templates
  module Slots
    # @see Templates::Slots::Compiler
    class Compile < Support::SimpleServiceOperation
      service_klass Templates::Slots::Compiler
    end
  end
end
