# frozen_string_literal: true

module Testing
  module GQL
    class SchemaErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        SchemaErrorBuilder.build(...)
      end
    end
  end
end
