# frozen_string_literal: true

module Layouts
  module Introspection
    class Validate
      include Dry::Monads[:result, :do]

      include MeruAPI::Deps[
        validate_params: "layouts.introspection.validate_params",
      ]

      def call(params)
        layout, xml = yield check!(params)

        parsed = yield parse! layout, xml

        result = yield introspect! parsed

        Success result
      end

      private

      def check!(params)
        result = validate_params.(params.to_unsafe_h)

        return Failure[:invalid_params, result] unless result.success?

        result => { layout_kind:, document:, }

        layout = ::Layout.find layout_kind

        xml = document.read

        Success [layout, xml]
      end

      # @param [Layout] layout
      # @param [String] xml
      # @return [Dry::Monads::Result]
      def parse!(layout, xml)
        parsed = layout.config_klass.from_xml(xml)
      rescue Shale::ParseError => e
        Failure[:invalid_document, e.message]
      else
        Success parsed
      end

      def introspect!(parsed)
        errors = []

        errors.concat(parsed.templates.errors)

        templates = parsed.templates.templates.map(&:introspect)

        result = { valid: errors.blank?, param_errors: [], errors:, templates: }

        Success result
      end
    end
  end
end
