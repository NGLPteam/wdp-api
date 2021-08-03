# frozen_string_literal: true

module Schemas
  module Static
    module Definitions
      class Map < Schemas::Static::AbstractMapping
        namespaced_versions true

        root_namespace "definitions"

        version_map_klass Schemas::Static::Definitions::VersionMap
      end
    end
  end
end
