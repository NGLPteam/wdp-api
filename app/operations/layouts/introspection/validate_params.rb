# frozen_string_literal: true

module Layouts
  module Introspection
    class ValidateParams < ApplicationContract
      config.types = ::Templates::TypeRegistry

      params do
        required(:layout_kind).value(:layout_kind)
        required(:document).value(:uploaded_file)
      end
    end
  end
end
