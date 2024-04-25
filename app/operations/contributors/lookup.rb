# frozen_string_literal: true

module Contributors
  # @see Contributors::Finder
  class Lookup
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

    def call(...)
      Contributors::Finder.new(...).call
    end
  end
end
