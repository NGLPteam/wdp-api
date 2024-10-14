# frozen_string_literal: true

module Entities
  # Render a _specific_ layout for an {HierarchicalEntity entity}.
  class RenderLayout < Support::SimpleServiceOperation
    service_klass Entities::LayoutRenderer
  end
end
