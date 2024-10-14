# frozen_string_literal: true

module Layouts
  # Render an {HierarchicalEntity entity} for a {LayoutDefinition}.
  class Render < Support::SimpleServiceOperation
    service_klass Layouts::Renderer
  end
end
