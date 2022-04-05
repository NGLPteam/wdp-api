# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # JATS has a bespoke `pub-date` element that can look like the following:
      #
      # ```xml
      # <pub-date>
      #   <year>2022</year>
      #   <month>03</year>
      #   <day>29</day>
      # </pub-date>
      # ```
      #
      # It requires some special handling in order to process into a {VariablePrecisionDate}.
      class ParsePubDate
        include Harvesting::Metadata::XMLExtraction

        error_context :date_parsing

        default_namespace! Namespaces[:jats]

        extract_values! do
          xpath :year, "./xmlns:year/text()", type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          xpath :month, "./xmlns:month/text()", type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          xpath :day, "./xmlns:day/text()", type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          on_struct do
            def to_variable_precision_date
              super(year, month, day)
            end
          end
        end

        # @param [Nokogiri::XML::Element] element
        # @return [VariablePrecisionDate]
        def call(element)
          with_element element do
            extract_values
          end.fmap do |values|
            values.to_variable_precision_date
          end.value_or do |fl|
            # :nocov:
            VariablePrecisionDate.none
            # :nocov:
          end
        end
      end
    end
  end
end
