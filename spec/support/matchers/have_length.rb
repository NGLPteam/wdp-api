# frozen_string_literal: true

RSpec::Matchers.define :have_length do |expected|
  match do |actual|
    @actual = Array(actual).size

    values_match? @actual, expected
  end
end
