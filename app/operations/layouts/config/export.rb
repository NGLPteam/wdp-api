# frozen_string_literal: true

module Layouts
  module Config
    # Export a {LayoutDefinition} to a config that can be serialized to XML.
    #
    # @see Templates::Config::Utility::AbstractLayout
    class Export < Support::SimpleServiceOperation
      service_klass Layouts::Config::Exporter
    end
  end
end
