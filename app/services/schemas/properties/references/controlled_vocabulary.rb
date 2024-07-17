# frozen_string_literal: true

module Schemas
  module Properties
    module References
      # Shared logic for referencing a {ControlledVocabulary}.
      module ControlledVocabulary
        extend ActiveSupport::Concern

        include Schemas::Properties::References::Model

        included do
          model_types! ::ControlledVocabularyItem

          attribute :wants, :string
        end

        # @return [ControlledVocabulary, nil]
        def configured_controlled_vocabulary
          ControlledVocabularySource.providing(wants)
        end

        def to_version_property_metadata
          super.tap do |h|
            h.merge!(wants:)
          end
        end
      end
    end
  end
end
