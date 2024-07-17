# frozen_string_literal: true

module Filtering
  module Scopes
    class ControlledVocabularySources < Filtering::FilterScope[ControlledVocabularySource]
      boolean_scope! :unsatisfied do |arg|
        arg.description "Fetch only sources that remain unsatisfied."
      end
    end
  end
end
