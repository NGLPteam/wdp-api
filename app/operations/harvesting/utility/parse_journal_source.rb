# frozen_string_literal: true

module Harvesting
  module Utility
    # Try to parse a journal citation that includes volume and issue metadata.
    #
    # @see Harvesting::Utility::ParsedJournalSource
    class ParseJournalSource
      include WDPAPI::Deps[
        extract_year: "harvesting.utility.extract_year",
      ]

      PATTERNS = [
        /\A.+?; Vol\.?? (?<volume>\d+),?? No\.?? (?<issue>\d+(?:-\d+)?) \((?<year>\d+)\)(?:; (?<fpage>\d+)(?:[^\d](?<lpage>\d+))?)?\z/,
        # "Special edition" issues", e.g. `Vol 50, No SE`
        /\A.+?; Vol\.?? (?<volume>\d+),?? No\.?? (?<issue>\S+) \((?<year>\d+)\)(?:; (?<fpage>\d+)(?:[^\d](?<lpage>\d+))?)?\z/,
        /\A.+?, vol (?<volume>\d+), iss (?<issue>\d+)\z/,
      ].freeze

      # @param [<String>] inputs
      # @return [Harvesting::Utility::ParsedJournalSource]
      # @return [nil] when there is no match
      def call(*inputs)
        inputs.flatten!

        inputs.each do |input|
          next if input.blank?

          PATTERNS.each do |pattern|
            match = pattern.match input

            next unless match

            return parse! input, match
          end

          anystyle = try_anystyle input

          return anystyle if anystyle.present?
        end

        return nil
      end

      private

      # @param [String] input
      # @return [Harvesting::Utility::ParsedJournalSource, nil]
      def try_anystyle(input)
        results = ::AnyStyle.parse input

        parsed = normalize_anystyle results.first

        return if parsed.blank?

        attrs = parsed.merge(input: input)

        Harvesting::Utility::ParsedJournalSource.new(**attrs)
      end

      # @param [String] input
      # @param [MatchData] match
      # @return [Harvesting::Utility::ParsedJournalSource]
      def parse!(input, match)
        attrs = { input: input }.merge(match.named_captures.symbolize_keys)

        Harvesting::Utility::ParsedJournalSource.new(**attrs)
      end

      def normalize_anystyle(result)
        return if result.blank? || !result.kind_of?(Hash)

        return unless result[:volume].present? && result[:issue].present?

        {}.tap do |h|
          result.each do |key, value|
            case key
            when :volume, :issue
              h[key] = value.first.presence
            when :pages
              fpage, lpage = value.first.scan(/\d+/)

              h[:fpage] = fpage
              h[:lpage] = lpage
            when :date
              h[:year] = extract_year.(value.first).value_or(nil)
            end
          end
        end
      end
    end
  end
end
