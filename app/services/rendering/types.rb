# frozen_string_literal: true

module Rendering
  # Types related to rendering {Layouts} / {Templates} for {Entities}.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Generation = String.constrained(uuid_v4: true)
  end
end
