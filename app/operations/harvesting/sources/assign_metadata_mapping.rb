# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::MetadataMappingAssigner
    class AssignMetadataMapping < Support::SimpleServiceOperation
      service_klass Harvesting::Sources::MetadataMappingAssigner
    end
  end
end
