# frozen_string_literal: true

module Templates
  module Slots
    # @see Templates::Slots::EnvironmentBuilder
    class BuildEnvironment < Support::SimpleServiceOperation
      service_klass Templates::Slots::EnvironmentBuilder
    end
  end
end
