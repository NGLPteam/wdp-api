# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # @abstract
      class AbstractDateDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        data_attrs! :date_type, type: :string
        data_attrs! :iso_8601_date, type: "params.date"

        after_initialize :extract_date!

        # @return [String]
        attr_reader :content

        alias to_s content

        # @return [VariablePrecisionDate]
        attr_reader :date

        # @return [Integer, nil]
        attr_reader :day

        # @return [Integer, nil]
        attr_reader :month

        # @return [Integer, nil]
        attr_reader :year

        private

        # @return [void]
        def extract_date!
          @year = try_to_parse_date_part @data.year
          @month = try_to_parse_date_part @data.month
          @day = try_to_parse_date_part @data.day

          @date_string = @data.iso_8601_date.presence || [@year, @month, @day].compact.join(?-)

          @date = VariablePrecisionDate.parse(@date_string)

          @content = @date.to_s
        end

        # @param [#content] part
        # @return [Integer, nil]
        def try_to_parse_date_part(part)
          part.try(:content).try(:to_i)
        end
      end
    end
  end
end
