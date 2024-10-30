# frozen_string_literal: true

module Templates
  module Config
    # @see Templates::Config::LayoutApplicator
    class ApplyLayout < Support::SimpleServiceOperation
      service_klass Templates::Config::LayoutApplicator
    end
  end
end
