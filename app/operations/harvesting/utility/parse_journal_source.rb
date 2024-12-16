# frozen_string_literal: true

module Harvesting
  module Utility
    # Try to parse a journal citation that includes volume and issue metadata.
    #
    # @see Harvesting::Utility::ParsedJournalSource
    class ParseJournalSource
      include MeruAPI::Deps[
        extract_year: "harvesting.utility.extract_year",
      ]
      include Dry::Effects.Resolve(:auto_create_volumes_and_issues)

      PATTERNS = [
        /\A.+?; Vol\.?? (?<volume>\d+),?? No\.?? (?<issue>\d+(?:-\d+)?) \((?<year>\d+)\)(?:; (?<fpage>\d+)(?:[^\d](?<lpage>\d+))?)?\z/,
        # "Special edition" issues", e.g. `Vol 50, No SE`
        /\A.+?; Vol\.?? (?<volume>\d+),?? No\.?? (?<issue>\S+) \((?<year>\d+)\)(?:; (?<fpage>\d+)(?:[^\d](?<lpage>\d+))?)?\z/,
        /\A.+?, vol (?<volume>\d+), iss (?<issue>\d+)\z/,
      ].freeze

      NO_ISSUE = /\A.+?; Vol(?:ume)?\.?? (?<volume>\d+)(?: \((?<year>\d{4})\))?/

      # @param [<String>] inputs
      # @return [Harvesting::Utility::ParsedJournalSource]
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

          next unless auto_create_volumes_and_issues?

          match = NO_ISSUE.match input

          next unless match

          return parse! input, match, issue: ?1
        end

        if auto_create_volumes_and_issues?
          return Harvesting::Utility::ParsedJournalSource.default_journal_source
        end

        return Harvesting::Utility::ParsedJournalSource.unknown
      end

      private

      def auto_create_volumes_and_issues?
        auto_create_volumes_and_issues { false }
      end

      # @param [String] input
      # @return [Harvesting::Utility::ParsedJournalSource, nil]
      def try_anystyle(input)
        results = ::AnyStyle.parse input

        parsed = normalize_anystyle results.first

        return if parsed.blank?

        attrs = parsed.merge(input:)

        Harvesting::Utility::ParsedJournalSource.new(**attrs)
      end

      # @param [String] input
      # @param [MatchData] match
      # @return [Harvesting::Utility::ParsedJournalSource]
      def parse!(input, match, **extra)
        attrs = { input: }.merge(match.named_captures.symbolize_keys).merge(**extra)

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
              if value.present? && value.first.kind_of?(String)
                fpage, lpage = value.first.scan(/\d+/)

                h[:fpage] = fpage
                h[:lpage] = lpage
              else
                h[:fpage] = h[:lpage] = nil
              end
            when :date
              h[:year] = extract_year.(value.first).value_or(nil)
            end
          end
        end
      end
    end
  end
end
