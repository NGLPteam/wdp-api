# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::ConfigBuilder
    class BuildConfig < Support::SimpleServiceOperation
      service_klass Templates::Instances::ConfigBuilder
    end
  end
end
