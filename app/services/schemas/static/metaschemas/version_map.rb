# frozen_string_literal: true

module Schemas
  module Static
    module Metaschemas
      class VersionMap < Schemas::Static::VersionMap
        version_klass Schemas::Static::Metaschemas::Version
      end
    end
  end
end
