# frozen_string_literal: true

module TestHelpers
  module Factories
    module SchemaHelpers
      ROOT = Rails.root.join("spec", "schemas")

      def testing_schema_configuration_for(name, version)
        schema_configuration_for "testing", name, version
      end

      def schema_configuration_for(namespace, name, version)
        path = ROOT.join(namespace.to_s, name.to_s, "#{version}.json")

        content = path.read

        parsed = JSON.parse content

        Schemas::Versions::Configuration.new(parsed)
      end
    end
  end
end
