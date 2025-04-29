# frozen_string_literal: true

module Metadata
  module OAIDC
    module Elements
      class Source < Metadata::OAIDC::AbstractElement
        xml do
          root "source"
        end

        def has_journal_source?
          journal_source.known?
        end

        def journal_source
          @journal_source ||= MeruAPI::Container["harvesting.utility.parse_journal_source"].(content)
        end
      end
    end
  end
end
