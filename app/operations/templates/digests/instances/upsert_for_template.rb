# frozen_string_literal: true

module Templates
  module Digests
    module Instances
      # @see Templates::Digests::Instances::TemplateUpserter
      class UpsertForTemplate < Support::SimpleServiceOperation
        service_klass Templates::Digests::Instances::TemplateUpserter
      end
    end
  end
end
