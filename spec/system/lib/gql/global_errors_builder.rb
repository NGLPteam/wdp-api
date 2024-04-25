# frozen_string_literal: true

module Testing
  module GQL
    class GlobalErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        GlobalErrorBuilder.build(...)
      end

      def coded_error(input, type: input.to_s, **options)
        error input, **options, type:
      end
    end
  end
end
