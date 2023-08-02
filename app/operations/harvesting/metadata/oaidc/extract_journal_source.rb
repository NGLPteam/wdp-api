# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # @see Harvesting::Utility::ParsedJournalSource
      class ExtractJournalSource
        include Harvesting::Metadata::XMLExtraction

        add_namespace! :dc, Namespaces[:dc]

        extract_values! do
          xpath :volume, ".//dc:volume", type: :string, require_match: true

          xpath :issue, ".//dc:issue", type: :string, require_match: true

          on_struct do
            attr_reader :fpage
            attr_reader :lpage
            attr_reader :year

            def to_parsed_journal_source
              Harvesting::Utility::ParsedJournalSource.new(
                input: "",
                volume: volume,
                issue: issue,
                fpage: fpage,
                lpage: lpage,
                year: year,
              )
            end
          end
        end

        def call(element)
          with_element element do
            extract_values
          end.fmap(&:to_parsed_journal_source)
        end
      end
    end
  end
end
