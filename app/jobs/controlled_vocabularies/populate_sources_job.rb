# frozen_string_literal: true

module ControlledVocabularies
  class PopulateSourcesJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      call_operation!("controlled_vocabularies.populate_sources")
    end
  end
end
