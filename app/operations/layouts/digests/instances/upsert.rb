# frozen_string_literal: true

module Layouts
  module Digests
    module Instances
      # @see Layouts::Digests::Instances::Upserter
      class Upsert < Support::SimpleServiceOperation
        service_klass Layouts::Digests::Instances::Upserter
      end
    end
  end
end
