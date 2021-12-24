# frozen_string_literal: true

module TestHelpers
  module XorMatcherSupport
    BOOLS = [true, false, nil].freeze

    def booleanize(value, by_presence: false)
      if value.in?(BOOLS)
        !!value
      elsif by_presence
        value.present?
      else
        Dry::Types["params.bool"].try(value).to_result.value_or do
          !!value
        end
      end
    end
  end
end

RSpec::Matchers.define :xor do |expected|
  include TestHelpers::XorMatcherSupport

  match do |actual|
    @expected = booleanize(expected, by_presence: @by_presence)

    @actual = booleanize(actual, by_presence: @by_presence)

    @expected ^ @actual
  end

  match_when_negated do |actual|
    @expected = booleanize(expected, by_presence: @by_presence)

    @actual = booleanize(actual, by_presence: @by_presence)

    @expected == @actual
  end

  chain :by_presence do
    @by_presence = true
  end

  description do
    "logically XORs #{@expected}#{' (by presence)' if @by_presence}"
  end

  failure_message do
    "expected that expected(#{@expected}) XOR actual(#{@actual})"
  end

  failure_message do
    "expected that NOT(expected(#{@expected}) XOR actual(#{@actual}))"
  end
end
