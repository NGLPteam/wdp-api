# frozen_string_literal: true

module Entities
  # Render all layouts for an {HierarchicalEntity entity}.
  class RenderLayouts < Support::SimpleServiceOperation
    service_klass Entities::LayoutsRenderer
  end
end
