# frozen_string_literal: true

module Templates
  module Config
    # Export a {TemplateDefinition} to a config that can be serialized to XML.
    #
    # @see Templates::Config::Utility::AbstractTemplate
    class Export < Support::SimpleServiceOperation
      service_klass Templates::Config::Exporter
    end
  end
end
