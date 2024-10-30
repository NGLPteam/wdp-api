# frozen_string_literal: true

module Templates
  module Config
    # @see Templates::Config::TemplateApplicator
    class ApplyTemplate < Support::SimpleServiceOperation
      service_klass Templates::Config::TemplateApplicator
    end
  end
end
