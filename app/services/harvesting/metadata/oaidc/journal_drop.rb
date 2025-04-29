# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class JournalDrop < ::Liquid::Drop
        # @param [Harvesting::Utility::ParsedJournalSource] journal_source
        def initialize(journal_source = nil)
          @journal_source = journal_source

          @volume = @journal_source&.volume
          @issue = @journal_source&.issue
          @exists = @journal_source&.valid?
        end

        # @return [Boolean]
        attr_reader :exists

        # @return [String, nil]
        attr_reader :issue

        # @return [String, nil]
        attr_reader :volume
      end
    end
  end
end
