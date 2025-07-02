# frozen_string_literal: true

module Entities
  # @see Entities::LayoutDefinitionsDeriver
  class DeriveLayoutDefinitions < Support::SimpleServiceOperation
    service_klass Entities::LayoutDefinitionsDeriver
  end
end
