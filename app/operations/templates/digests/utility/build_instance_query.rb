# frozen_string_literal: true

module Templates
  module Digests
    module Utility
      # @see Templates::Digests::Utility::InstanceQueryBuilder
      class BuildInstanceQuery < Support::SimpleServiceOperation
        service_klass Templates::Digests::Utility::InstanceQueryBuilder
      end
    end
  end
end
