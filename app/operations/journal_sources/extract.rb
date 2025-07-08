# frozen_string_literal: true

module JournalSources
  class Extract
    include Dry::Monads[:maybe]

    PAGES_PATTERN = /\d+/

    YEAR_PATTERN = /(?<year>\d{4})/

    # @note This is only really used in tests.
    # @return [Dry::Monads::Result]
    def call(type, ...)
      case type
      in :first_string
        first_string(...)
      in :pages
        pages(...)
      in :year
        year(...)
      end.to_result
    end

    # @param [<String>, String] input
    # @return [Dry::Monads::Maybe(String)]
    def first_string(input)
      case input
      in [String => value, *]
        Maybe(value.presence)
      in String => value
        Maybe(value.presence)
      else
        None()
      end
    end

    # @param [<String>, String] input
    # @return [Dry::Monads::Maybe(Hash)]
    def pages(input)
      case input
      in [PAGES_PATTERN => possible, *]
        pages(possible)
      in PAGES_PATTERN
        fpage, lpage, * = input.scan(PAGES_PATTERN).map(&:to_i)

        Some({ fpage:, lpage:, })
      else
        None()
      end
    end

    # @param [<String>, String] input
    # @return [Dry::Monads::Maybe(Integer)]
    def year(input)
      case input
      in [String => possible_year, *]
        year(possible_year)
      in YEAR_PATTERN => matched
        Some Regexp.last_match[:year].to_i
      else
        None()
      end
    end
  end
end
