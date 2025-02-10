# frozen_string_literal: true

module Templates
  module Digests
    module Instances
      # @see Templates::Digests::Instances::LayoutUpserter
      class UpsertForLayout < Support::SimpleServiceOperation
        service_klass Templates::Digests::Instances::LayoutUpserter
      end
    end
  end
end
