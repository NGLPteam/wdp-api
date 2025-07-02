# frozen_string_literal: true

module Templates
  module Digests
    module Definitions
      # @see Templates::Digests::Definitions::Upserter
      class Upsert < Support::SimpleServiceOperation
        service_klass Templates::Digests::Definitions::Upserter
      end
    end
  end
end
