# frozen_string_literal: true

module Filtering
  module Scopes
    class ControlledVocabularies < Filtering::FilterScope[ControlledVocabulary]
      simple_filter! :namespace, :string
      simple_filter! :identifier, :string
      simple_filter! :provides, :string
    end
  end
end
