# frozen_string_literal: true

module Schemas
  module Versions
    class PopulateRootLayouts < Support::SimpleServiceOperation
      service_klass Schemas::Versions::RootLayoutsPopulator
    end
  end
end
