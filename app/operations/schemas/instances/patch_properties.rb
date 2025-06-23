# frozen_string_literal: true

module Schemas
  module Instances
    # @see Schemas::Instances::PropertiesPatcher
    class PatchProperties < Support::SimpleServiceOperation
      service_klass Schemas::Instances::PropertiesPatcher
    end
  end
end
