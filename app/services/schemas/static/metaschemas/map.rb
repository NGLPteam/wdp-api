# frozen_string_literal: true

module Schemas
  module Static
    module Metaschemas
      class Map < Schemas::Static::AbstractMapping
        root_namespace "metaschemas"

        version_map_klass Schemas::Static::Metaschemas::VersionMap
      end
    end
  end
end
