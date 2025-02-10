# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::ConfigBuilder
    class BuildConfig < Support::SimpleServiceOperation
      service_klass Templates::Definitions::ConfigBuilder
    end
  end
end
